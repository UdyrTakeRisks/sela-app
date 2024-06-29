using System.Text.Json;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using selaApplication.Dtos;
using selaApplication.Models;
using selaApplication.Services;
using selaApplication.Services.Admin;
using selaApplication.Services.Post;
using selaApplication.Services.User;

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

    public AdminController(IAdminService adminService)
    {
        _adminService = adminService;
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
            return Ok("User deleted successfully");
        
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
            return Ok("Post deleted successfully");
        
        return BadRequest("Failed to delete the post");
    }

    // view users info - should log in first
    [HttpGet("/view/users")]
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

        var users = await _adminService.GetAllUsers();
        var enumerable = users.ToList();
        if (!enumerable.Any())
            return NotFound("No users found.");
        
        return Ok(enumerable);
    }
    
    
    // view post reports - should log in first
    
}
