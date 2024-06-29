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


    //private readonly IConfiguration _configuration;
    private readonly IAdminService _adminService;

    public AdminController(IAdminService adminService)
    {
        //_configuration = configuration;
        _adminService = adminService;
    }

    [HttpGet("health")]

    public Task<IActionResult> CheckAppHealth()
    {
        var jsonData = new { Health = "Good", SELA = "Working", Type = "Admin" };
        return Task.FromResult<IActionResult>(new JsonResult(jsonData));
    }
    

    [HttpPost("login")]
    public async Task<IActionResult> LoginAdminAsync(UserLoginDto dto) //
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

        if (admin.username.Equals("admin") && admin.password.Equals("admin")) // testing
        {
            // session to store admin obj state
            HttpContext.Session.SetString("AdminSession", JsonSerializer.Serialize(admin));

            // to retrieve the session
            // var serializedObj = HttpContext.Session.GetString("AdminSession");
            // var adminUser = JsonSerializer.Deserialize<Admin>(serializedObj);

            return Ok("Admin logged in Successfully");
        }

        // var jsonData = new { key1 = "test1", key2 = "test2" };
        // return new JsonResult(jsonData);
        return Unauthorized("You are unauthorized to log in");
    }



    [HttpDelete("user/{userId}")]
    public async Task<IActionResult> DeleteUser(int userId)
    {
        var result = await _adminService.DeleteUser(userId);
        if (result)
            return Ok("User deleted successfully");
        else
            return BadRequest("Failed to delete the user");
    }


    [HttpDelete("post/{postId}")]
    public async Task<IActionResult> DeletePost(int postId)
    {
        var result = await _adminService.DeletePost(postId);
        if (result)
            return Ok("Post deleted successfully");
        else
            return BadRequest("Failed to delete the post");
    }

}
