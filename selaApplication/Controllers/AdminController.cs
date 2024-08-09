using System.Text.Json;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Distributed;
using Microsoft.Extensions.Caching.Memory;
using selaApplication.Dtos;
using selaApplication.Models;
using selaApplication.Services;
using selaApplication.Services.Admin;
using selaApplication.Services.Post;
using selaApplication.Services.User;
using StackExchange.Redis;

namespace selaApplication.Controllers;

[ApiController]
[Route("api/[controller]")]
//[Authorize]
public class AdminController : ControllerBase
{
    // admin will log in with known credentials, should be encrypted 
    // but will have to verify an otp that should (should get a third party sms provider)
    // be sent on one of our phone numbers to validate
    // that the admin is authorized to log in, or we can use JWTs
    
    private readonly IAdminService _adminService;
    private readonly IConnectionMultiplexer _redis;
    private readonly IDistributedCache _distributedCache;
    private readonly IMemoryCache _memoryCache;
    private const string AllUsersCacheKey = "allUsersList";
    
    public AdminController(IAdminService adminService, IConnectionMultiplexer redis, IDistributedCache distributedCache, IMemoryCache memoryCache)
    {
        _adminService = adminService;
        _redis = redis;
        _distributedCache = distributedCache;
        _memoryCache = memoryCache;
    }

    [HttpGet("health")]
    public Task<IActionResult> CheckAppHealth()
    {
        var jsonData = new { Health = "Good", SELA = "Working", Type = "Admin" };
        return Task.FromResult<IActionResult>(new JsonResult(jsonData));
    }
    

    [HttpPost("login")]
    public IActionResult LoginAdmin(UserLoginDto dto) // password could be a generated JWT
    {
        // tracing the input 
        Console.WriteLine($"Received Username: {dto.username}");
        Console.WriteLine($"Received Password: {dto.password}");

        var admin = new Admin
        {
            username = dto.username,
            password = dto.password
        };

        //validate user credentials
        if (string.IsNullOrEmpty(admin.username) || string.IsNullOrEmpty(admin.password))
            // return Forbid("Username or Password can not be empty");
            return BadRequest("Username or Password can not be empty");

        if (!admin.username.Equals("admin") || !admin.password.Equals("admin")) // testing
            return Unauthorized("You are unauthorized to log in");
        
        // session to store admin obj state
        HttpContext.Session.SetString("AdminSession", JsonSerializer.Serialize(admin));
        var cookieExpirationTimestamp = DateTime.UtcNow.AddDays(1);

        var response = new
        {
            message = "Admin logged in Successfully",
            cookieExpirationTimestamp
        };    
        return Ok(response);
    }

    [HttpPost("logout")]
    public IActionResult LogoutAdmin()
    {
        var serializedAdminObj = HttpContext.Session.GetString("AdminSession");
        if (serializedAdminObj == null)
        {
            return Unauthorized("You already logged out");
        }

        HttpContext.Session.Remove("AdminSession");

        return Ok("Admin logged out successfully");
    }
    
    [HttpDelete("delete/user/{userId:int}")]
    public async Task<IActionResult> DeleteUserAsync(int userId)
    {
        var serializedAdminObj = HttpContext.Session.GetString("AdminSession");
        if (serializedAdminObj == null)
        {
            return Unauthorized("You should log in first to delete user account.");
        }

        var sessionAdmin = JsonSerializer.Deserialize<Admin>(serializedAdminObj);
        if (sessionAdmin == null)
        {
            return Unauthorized("Admin Session is expired. Please log in first.");
        }
        
        var result = await _adminService.DeleteUser(userId);
        if (result)
        {
            // should delete caches
            var redisCache = _redis.GetDatabase();
            await redisCache.KeyDeleteAsync(AllUsersCacheKey);
            
            return Ok("User deleted successfully");
        }

        return BadRequest("Failed to delete the user");
    }


    [HttpDelete("delete/post/{postId:int}")]
    public async Task<IActionResult> DeletePostAsync(int postId)
    {
        var serializedAdminObj = HttpContext.Session.GetString("AdminSession");
        if (serializedAdminObj == null)
        {
            return Unauthorized("You should log in first to delete post.");
        }

        var sessionAdmin = JsonSerializer.Deserialize<Admin>(serializedAdminObj);
        if (sessionAdmin == null)
        {
            return Unauthorized("Admin Session is expired. Please log in first.");
        }
        
        var result = await _adminService.DeletePost(postId);
        if (result)
        {
            // should delete caches
            await _distributedCache.RemoveAsync("OrganizationPosts");
            _memoryCache.Remove("IndividualPosts");
            
            return Ok("Post deleted successfully");
        }

        return BadRequest("Failed to delete the post");
    }

    // view users info - should log in first - cached
    [HttpGet("view/users")]
    public async Task<IActionResult> DisplayUsersAsync()
    {
        var serializedAdminObj = HttpContext.Session.GetString("AdminSession");
        if (serializedAdminObj == null)
        {
            return Unauthorized("You should log in first to view users.");
        }

        var sessionAdmin = JsonSerializer.Deserialize<Admin>(serializedAdminObj);
        if (sessionAdmin == null)
        {
            return Unauthorized("Admin Session is expired. Please log in first.");
        }

        var redisCache = _redis.GetDatabase();
        var cachedUsers = await redisCache.StringGetAsync(AllUsersCacheKey);
        if (cachedUsers.IsNullOrEmpty)
        {
            var usersInDb = await _adminService.GetAllUsers();
            var enumerableUsers = usersInDb.ToList();
            if (!enumerableUsers.Any())
                return NotFound("No users found.");

            var serializedUsers = JsonSerializer.Serialize(enumerableUsers);
            await redisCache.StringSetAsync(AllUsersCacheKey, serializedUsers, TimeSpan.FromHours(1));
            
            return Ok(enumerableUsers);
        }

        var users = JsonSerializer.Deserialize<IEnumerable<User>>(cachedUsers);

        return Ok(users);
    }

    [HttpGet("edit/post/{postId:int}")]
    public async Task<IActionResult> EditPostsAsync(int postId, PostDto dto)
    {
        
        var serializedAdminObj = HttpContext.Session.GetString("AdminSession");
        if (serializedAdminObj == null)
        {
            return Unauthorized("You should log in first to view users.");
        }

        var sessionAdmin = JsonSerializer.Deserialize<Admin>(serializedAdminObj);
        if (sessionAdmin == null)
        {
            return Unauthorized("Admin Session is expired. Please log in first.");
        }
        
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

        var result = await _adminService.UpdatePosts(postId, post);

        await _distributedCache.RemoveAsync("OrganizationPosts");
        _memoryCache.Remove("IndividualPosts");
        // _memoryCache.Remove($"{sessionAdmin.username}_Posts");
        
        return Ok(result);
    }
    
}
