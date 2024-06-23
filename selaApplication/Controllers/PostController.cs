using Microsoft.AspNetCore.Mvc;
using selaApplication.Dtos;
using selaApplication.Models;
using selaApplication.Services.Post;
using selaApplication.Services.User;
using System.Text.Json;

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

    [HttpPut("update/{id}")]
    public async Task<IActionResult> EditPostAsync(int id, PostDto dto)
    {
        if (dto == null) // the required annotations already handle this
        {
            return BadRequest("Invalid post data.");
        }

        var serializedUserObj = HttpContext.Session.GetString("UserSession");
        if (serializedUserObj == null)
        {
            return Unauthorized("You should login first to edit a post");
        }
        
        var sessionUser = JsonSerializer.Deserialize<User>(serializedUserObj);
        if (sessionUser == null)
        {
            return Unauthorized("User Session is Expired. Please log in first.");
        }
        
        var userId = await _usersService.GetIdByUsername(sessionUser.username);
        //var post = await _postsService.GetPostById(id); // is this matters ? redundant database hit, use id directly in update

        // if (post == null || post.UserId != userId)
        // {
        //     return NotFound("Post not found or you don't have permission to edit this post.");
        // }
        // just create a new post obj and pass it to the update
        var post = new Post
        {
            // Update the post with the new data from dto
            Type = dto.Type,
            title = dto.title,
            description = dto.description,
            about = dto.about,
            socialLinks = dto.socialLinks,

            ImageUrLs = dto.ImageUrLs,
            name = dto.name,
            tags = dto.tags,
            providers = dto.providers
        };
        // Log the post data for debugging
        Console.WriteLine($"Updating Post: {JsonSerializer.Serialize(post)}");

        var result = await _postsService.UpdatePost(post, id, userId);

        return Ok(result);
    }


    [HttpDelete("delete/{id}")]
    public async Task<IActionResult> RemovePostAsync(int id)
    {
        var serializedUserObj = HttpContext.Session.GetString("UserSession");
        if (serializedUserObj == null)
        {
            return Unauthorized("You should login first to delete a post");
        }

        var sessionUser = JsonSerializer.Deserialize<User>(serializedUserObj);
        if (sessionUser == null)
        {
            return Unauthorized("User Session is Expired. Please log in first.");
        }

        var userId = await _usersService.GetIdByUsername(sessionUser.username);
        // var post = await _postsService.GetPostById(id); // redundant database hit

        // if (post == null || post.UserId != userId)
        // {
        //     return NotFound("Post not found or you don't have permission to delete this post.");
        // }

        // var res = "";
        // try
        // {
        var res = await _postsService.DeletePost(id, userId);
        // }
        // catch (Exception)
        // {
        //     return StatusCode(500, "Error deleting the post. Please try again.");
        // }

        return Ok(res);
    }

    [HttpGet("myPosts")]
    public async Task<ActionResult<IEnumerable<Post>>> ShowMyPostsAsync()
    {
        // Retrieve user session
        var serializedUserObj = HttpContext.Session.GetString("UserSession");
        if (serializedUserObj == null)
            return Unauthorized("Please login first to see your posts.");

        var sessionUser = JsonSerializer.Deserialize<User>(serializedUserObj);
        if (sessionUser == null)
            return Unauthorized("Invalid user session. Please login again.");

        Console.WriteLine("User Username: " + sessionUser.username + " User Pass: " + sessionUser.password);

        var userId = await _usersService.GetIdByUsername(sessionUser.username);
        var posts = await _postsService.ShowPostsById(userId);

        if (!posts.Any())
            return NotFound("No posts found for this user.");

        return Ok(posts);
    }

    [HttpGet("search")]
    public async Task<IActionResult> SearchPostsAsync([FromQuery] string query)
    {
        if (string.IsNullOrWhiteSpace(query))
        {
            return BadRequest("Search query cannot be empty");
        }

        var posts = await _postsService.SearchPosts(query);
        if (posts == null || !posts.Any())
        {
            return NotFound("No posts found matching the search query");
        }

        return Ok(posts);
    }


}