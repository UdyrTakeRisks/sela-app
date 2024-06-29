using Microsoft.AspNetCore.Mvc;
using selaApplication.Dtos;
using selaApplication.Helpers;
using selaApplication.Models;
using selaApplication.Services.User;
using System.Text.Json;

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

            if (!UserHelper.ValidateEmail(dto.email))
            {
                return BadRequest("Invalid email format.");
            }

            // Validate the new phone number format
            if (!UserHelper.ValidatePhoneNumber(dto.phoneNumber))
            {
                return BadRequest("Invalid phone number format.");
            }
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

        // update user account endpoint - not done - front should send the cookie
        [HttpPut("update/photo")]
        public async Task<IActionResult> UpdateUserPhotoAsync(UserPhotoDto dto)
        {
            var serializedUserObj = HttpContext.Session.GetString("UserSession");
            if (serializedUserObj == null)
            {
                return Unauthorized("You should login first to update your account");
            }

            var sessionUser = JsonSerializer.Deserialize<User>(serializedUserObj);
            if (sessionUser == null)
            {
                return Unauthorized("User Session is Expired. Please log in first.");
            }

            var userId = await _usersService.GetIdByUsername(sessionUser.username);

            var userPhoto = dto.userPhoto;



            //update user photo in database
            var response = await _usersService.UpdateUserPhoto(userId, userPhoto);
            return Ok(response);
        }

        // update user details - update it all or update each one alone ? - front should send the cookie
        [HttpPut("update/details")]
        public async Task<IActionResult> UpdateUserDetailsAsync(UserDto dto)
        {
            var serializedUserObj = HttpContext.Session.GetString("UserSession");
            if (serializedUserObj == null)
            {
                return Unauthorized("You should login first to update your account");
            }

            var sessionUser = JsonSerializer.Deserialize<User>(serializedUserObj);
            if (sessionUser == null)
            {
                return Unauthorized("User Session is Expired. Please log in first.");
            }

            var userId = await _usersService.GetIdByUsername(sessionUser.username);

            var userUpdate = new User
            {
                userPhoto = dto.userPhoto,
                username = dto.username,
                name = dto.name,
                email = dto.email,
                phoneNumber = dto.phoneNumber,
                password = dto.password
            };
            //update user details in database

            return Ok();
        }

        [HttpPut("update/name")]
        public async Task<IActionResult> UpdateNameAsync(UserNameDto dto)
        {
            var serializedUserObj = HttpContext.Session.GetString("UserSession");
            if (serializedUserObj == null)
            {
                return Unauthorized("You should login first to update your account");
            }

            var sessionUser = JsonSerializer.Deserialize<User>(serializedUserObj);
            if (sessionUser == null)
            {
                return Unauthorized("User Session is Expired. Please log in first.");
            }

            var userId = await _usersService.GetIdByUsername(sessionUser.username);

            var newName = dto.name;

            //update user name in database
            var response = await _usersService.UpdateNameById(userId, newName);
            return Ok(response);
        }

        [HttpPut("update/email")]
        public async Task<IActionResult> UpdateEmailAsync(UserEmailDto dto)
        {
            var serializedUserObj = HttpContext.Session.GetString("UserSession");
            if (serializedUserObj == null)
            {
                return Unauthorized("You should login first to update your account");
            }

            var sessionUser = JsonSerializer.Deserialize<User>(serializedUserObj);
            if (sessionUser == null)
            {
                return Unauthorized("User Session is Expired. Please log in first.");
            }

            var userId = await _usersService.GetIdByUsername(sessionUser.username);

            var newEmail = dto.email;

            // Validate new email format before updating
            if (!UserHelper.ValidateEmail(newEmail))
            {
                return BadRequest("Invalid email format.");
            }

            //update user email in database
            var response = await _usersService.UpdateEmailById(userId, newEmail);

            return Ok(response);

        }

        [HttpPut("update/phone")]
        public async Task<IActionResult> UpdatePhoneNumberAsync(UserPhoneDto dto)
        {
            var serializedUserObj = HttpContext.Session.GetString("UserSession");
            if (serializedUserObj == null)
            {
                return Unauthorized("You should login first to update your account");
            }

            var sessionUser = JsonSerializer.Deserialize<User>(serializedUserObj);
            if (sessionUser == null)
            {
                return Unauthorized("User Session is Expired. Please log in first.");
            }

            var userId = await _usersService.GetIdByUsername(sessionUser.username);

            var newPhoneNumber = dto.phoneNumber;

            // Validate the new phone number format
            if (!UserHelper.ValidatePhoneNumber(newPhoneNumber))
            {
                return BadRequest("Invalid phone number format.");
            }

            //update user phone number in database
            var response = await _usersService.UpdatePhoneNumberById(userId, newPhoneNumber);

            return Ok(response);
        }

        [HttpPut("update/password")]
        public async Task<IActionResult> UpdatePasswordAsync(UserPasswordDto dto)
        {
            var serializedUserObj = HttpContext.Session.GetString("UserSession");
            if (serializedUserObj == null)
            {
                return Unauthorized("You should log in first to update your account.");
            }

            var sessionUser = JsonSerializer.Deserialize<User>(serializedUserObj);
            if (sessionUser == null)
            {
                return Unauthorized("User Session is expired. Please log in first.");
            }

            if (string.IsNullOrEmpty(dto.newPassword))
            {
                return BadRequest("New password cannot be empty.");
            }

            var userId = await _usersService.GetIdByUsername(sessionUser.username);

            if (userId == 0)
            {
                return NotFound("User not found.");
            }

            var existingUserPassword = await _usersService.GetPasswordById(userId);
            var isOldPasswordValid = UserHelper.VerifyPassword(dto.oldPassword, existingUserPassword);
            if (!isOldPasswordValid)
            {
                return BadRequest("Old password is incorrect.");
            }

            var hashedNewPassword = UserHelper.HashPassword(dto.newPassword);

            var response = await _usersService.UpdatePasswordById(userId, hashedNewPassword);

            return Ok("Password updated successfully.");
        }


        [HttpGet("view/photo")]
        public async Task<IActionResult> GetUserPhotoAsync()
        {
            var serializedUserObj = HttpContext.Session.GetString("UserSession");
            if (serializedUserObj == null)
            {
                return Unauthorized("You should login first to view your account");
            }

            var sessionUser = JsonSerializer.Deserialize<User>(serializedUserObj);
            if (sessionUser == null)
            {
                return Unauthorized("User Session is Expired. Please log in first.");
            }

            var userId = await _usersService.GetIdByUsername(sessionUser.username);

            var userPhoto = await _usersService.GetUserPhoto(userId);

            return Ok(userPhoto);
        }






        // delete user account endpoint - front should send the cookie
        [HttpDelete("delete")]
        public async Task<IActionResult> RemoveUserAsync()
        {
            var serializedUserObj = HttpContext.Session.GetString("UserSession");
            if (serializedUserObj == null)
            {
                return Unauthorized("You should login first to remove your account");
            }

            var sessionUser = JsonSerializer.Deserialize<User>(serializedUserObj);
            if (sessionUser == null)
            {
                return Unauthorized("User Session is Expired. Please log in first.");
            }

            var userId = await _usersService.GetIdByUsername(sessionUser.username);

            var result = await _usersService.DeleteUser(userId);

            return Ok(result);
        }
    }
}