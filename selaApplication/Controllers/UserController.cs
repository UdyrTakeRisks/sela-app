using System.Text.Json;
using Microsoft.AspNetCore.Mvc;
using selaApplication.Dtos;
using selaApplication.Models;
using selaApplication.Services;
using selaApplication.Helpers;
using selaApplication.Services.User;

namespace selaApplication.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UserController : ControllerBase
    {
        private readonly IUserService _usersService;

        public UserController(IUserService usersService)
        {
            _usersService = usersService;
        }

        [HttpGet("health")]
        // [Route("/health")]
        public Task<IActionResult> CheckAppHealth()
        {
            var jsonData = new { Health = "Good", SELA = "Working", Type = "User" };
            return Task.FromResult<IActionResult>(new JsonResult(jsonData));
        }

        [HttpPost("signup")]
        // [Route("/signup/user")]
        public async Task<IActionResult> RegisterUserAsync(UserDto dto)
        {
            // validate credentials using regex before adding it to the database

            var user = new User
            {
                username = dto.username,
                name = dto.name,
                email = dto.email,
                phoneNumber = dto.phoneNumber,
                password = dto.password
            };
            //validate user credentials before adding him to database
            if (string.IsNullOrEmpty(user.username) || string.IsNullOrEmpty(user.password))
                // return Forbid("Username or Password can not be empty");
                return BadRequest("Username or Password can not be empty");

            var existingUsername = await _usersService.GetByUsername(user.username);
            if (existingUsername != null)
                return BadRequest($"User with username: {user.username} already exists");

            var hashedPassword = UserHelper.HashPassword(user.password);
            user.password = hashedPassword;

            await _usersService.AddUser(user);
            // return Ok(user);
            return Ok("User Registered Successfully");
        }

        [HttpPost("login")]
        // [Route("/login/user")]
        public async Task<IActionResult> LoginUserAsync(UserLoginDto dto)
        {
            var user = new User
            {
                username = dto.username,
                password = dto.password
            };

            //validate user credentials
            if (string.IsNullOrEmpty(user.username) || string.IsNullOrEmpty(user.password))
                // return Forbid("Username or Password can not be empty");
                return BadRequest("Username or Password can not be empty");

            var userInDb = await _usersService.GetByUsername(user.username);
            if (userInDb == null)
                return NotFound("User is not found.");

            var hashedInputPassword = UserHelper.HashPassword(user.password);
            if (hashedInputPassword.Equals(userInDb.password))
            {
                // session to store user obj state
                // HANDLE CASE: IF USER TRIES TO LOGIN FROM DIFFERENT DEVICES, DON'T TRY TO CREATE A NEW SESSION AS THERE WILL BE EXISTING ONE IF LOGGED BEFORE
                // var serializedObj = HttpContext.Session.GetString("UserSession");
                // var sessionUser = JsonSerializer.Deserialize<User>(serializedObj);
                // if(sessionUser == null) // test condition
                HttpContext.Session.SetString("UserSession", JsonSerializer.Serialize(user));

                var cookieExpirationTimestamp = DateTime.UtcNow.AddDays(1);
                // var cookieExpirationTimestampV2 = TimeSpan.FromDays(1);

                var response = new
                {
                    message = "User logged in Successfully",
                    cookieExpirationTimestamp
                    // cookieExpirationTimestampV2
                };
                return Ok(response); // add user login timestamp to check cookie validation on frontend
            }
            
            return Unauthorized("You are unauthorized to log in");
        }
        
        // log out
        [HttpPost("logout")]
        public IActionResult LogoutUser()
        {
            var serializedUserObj = HttpContext.Session.GetString("UserSession");
            if (serializedUserObj == null)
            {
                return Unauthorized("You already logged out");
            }
            
            HttpContext.Session.Remove("UserSession");
            return Ok("User logged out successfully");
        }
        
        // update user account endpoint
        
        // delete user account endpoint
        
    }
    
}