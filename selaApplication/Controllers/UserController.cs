using Microsoft.AspNetCore.Mvc;
using selaApplication.Dtos;
using selaApplication.Models;
using selaApplication.Services;
using selaApplication.Helpers;

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

        [HttpGet]
        [Route("/health")]
        public Task<IActionResult> CheckAppHealth()
        {
            var jsonData = new { Health = "Good", SELA = "Working" };
            return Task.FromResult<IActionResult>(new JsonResult(jsonData));
        }
        
        [HttpPost]
        [Route("/signup/user")]
        public async Task<IActionResult> RegisterUserAsync(UserDto dto)
        {
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

        [HttpPost]
        [Route("/login/user")]
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
                
                return Ok("User logged in Successfully");

            // var jsonData = new { key1 = "test1", key2 = "test2" };
            // return new JsonResult(jsonData);
            return Unauthorized("You are unauthorized to log in");
        }

        
    }
}