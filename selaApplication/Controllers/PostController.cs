using System.Text.Json;
using Microsoft.AspNetCore.Mvc;
using selaApplication.Dtos;
using selaApplication.Models;
using selaApplication.Services.Post;
using selaApplication.Services.User;

namespace selaApplication.Controllers;

[ApiController]
[Route("api/[controller]")]
public class PostController : ControllerBase
{
    // should do CRUD operations on posts
    // follow the prototype logic to cope with it

    private readonly IPostService _postsService;
    private readonly IUserService _usersService;

    public PostController(IPostService postsService, IUserService usersService)
    {
        _postsService = postsService;
        _usersService = usersService;
    }

    [HttpGet("health")]
    public Task<IActionResult> CheckAppHealth()
    {
        var jsonData = new { Health = "Good", SELA = "Working", Type = "Post" };
        return Task.FromResult<IActionResult>(new JsonResult(jsonData));
    }

    [HttpPost("user")]
    public async Task<IActionResult> CreateUserPostAsync(PostDto dto)
    {
        // retrieve user sessions
        var serializedUserObj = HttpContext.Session.GetString("UserSession");

        if (serializedUserObj == null)
        {
            return Unauthorized("You should login first to add a post");
        }

        var sessionUser = JsonSerializer.Deserialize<User>(serializedUserObj);
        if (sessionUser == null)
            return Unauthorized("User Session is Expired please log in first");

        Console.WriteLine("User Username: " + sessionUser.username + " User Pass: " + sessionUser.password);

        var post = new Post
        {
            ImageUrLs = dto.ImageUrLs,
            name = dto.name,
            Type = dto.Type,
            tags = dto.tags,
            title = dto.title,
            description = dto.description,
            providers = dto.providers,
            about = dto.about,
            socialLinks = dto.socialLinks
        };

        //validate user credentials before adding him to database
        // if (string.IsNullOrEmpty(user.username) || string.IsNullOrEmpty(user.password))
        //     // return Forbid("Username or Password can not be empty");
        //     return BadRequest("Username or Password can not be empty");

        var userId = await _usersService.GetIdByUsername(sessionUser.username);
        var res = await _postsService.AddUserPost(post, userId);
        // return Ok(user);
        return Ok(res);
    }

    [HttpPost("admin")]
    public async Task<IActionResult> CreateAdminPostAsync(PostDto dto)
    {
        // retrieve admin sessions
        var serializedAdminObj = HttpContext.Session.GetString("AdminSession");

        if (serializedAdminObj == null)
        {
            return Unauthorized("You should login first to add a post");
        }

        var sessionAdmin = JsonSerializer.Deserialize<Admin>(serializedAdminObj);
        if (sessionAdmin == null)
            return Unauthorized("Admin Session is Expired please log in first");

        Console.WriteLine("Admin Username: " + sessionAdmin.username + " Admin Pass: " + sessionAdmin.password);

        var post = new Post
        {
            ImageUrLs = dto.ImageUrLs,
            name = dto.name,
            Type = dto.Type,
            title = dto.title,
            description = dto.description,
            about = dto.about,
            socialLinks = dto.socialLinks
        };

        //validate user credentials before adding him to database
        // if (string.IsNullOrEmpty(user.username) || string.IsNullOrEmpty(user.password))
        //     // return Forbid("Username or Password can not be empty");
        //     return BadRequest("Username or Password can not be empty");

        await _postsService.AddAdminPost(post);
        // return Ok(user);
        return Ok("Post has been added Successfully");
    }

    [HttpGet("view/all/orgs")]
    public async Task<IEnumerable<Post>> ViewOrganizationPostsAsync()
    {
        var post = new Post { Type = PostType.Organization };
        // handle caching results with timeouts to enhance the performance
        return await _postsService.GetPosts(post);
    }

    [HttpGet("view/all/individuals")]
    public async Task<IEnumerable<Post>> ViewIndividualPostsAsync()
    {
        var post = new Post { Type = PostType.Individual };
        // handle caching results with timeouts to enhance the performance
        return await _postsService.GetPosts(post);
    }

    [HttpPut]
    public async Task<IActionResult> EditPostAsync(PostDto dto) // update according to post name coming from front
    {
        return Ok();
    }

    [HttpDelete]
    public async Task<IActionResult> RemovePostAsync(PostDto dto) // delete according to post name coming from front
    {
        return Ok();
    }

    [HttpGet("myPosts")]
    public async Task<IEnumerable<Post>> ShowMyPostsAsync() // test this method
    {
        // retrieve user sessions
        var serializedUserObj = HttpContext.Session.GetString("UserSession");
        if (serializedUserObj == null)
            return null; // if null returned, frontend has to pop up a msg to the user to login first in order to show his posts
        var sessionUser = JsonSerializer.Deserialize<User>(serializedUserObj);
        if (sessionUser == null)
            return null;

        Console.WriteLine("User Username: " + sessionUser.username + " User Pass: " + sessionUser.password);
        
        var userId = await _usersService.GetIdByUsername(sessionUser.username);
        return await _postsService.ShowPostsById(userId);
    }
    
}