using Microsoft.AspNetCore.Mvc;
using selaApplication.Dtos;
using selaApplication.Helpers;
using selaApplication.Models;
using selaApplication.Services.User;
using System.Text.Json;
using Microsoft.Extensions.Caching.Memory;
using StackExchange.Redis;

namespace selaApplication.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UserController : ControllerBase
    {
        private readonly IUserService _usersService;
        private readonly IMemoryCache _memoryCache;
        private readonly IConnectionMultiplexer _redis;
        
        public UserController(IUserService usersService, IMemoryCache memoryCache, IConnectionMultiplexer redis)
        {
            _usersService = usersService;
            _memoryCache = memoryCache;
            _redis = redis;
        }

        [HttpGet("health")]
        public Task<IActionResult> CheckAppHealth()
        {
            var jsonData = new { Health = "Good", SELA = "Working", Type = "User" };
            return Task.FromResult<IActionResult>(new JsonResult(jsonData));
        }

        [HttpPost("signup")]
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

            var response = await _usersService.AddUser(user);
            // return Ok(user);

            return Ok(response);
        }

        [HttpPost("login")]
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
            
            _memoryCache.Remove($"{sessionUser.username}_Photo");
            return Ok(response);
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
            
            _memoryCache.Remove($"{sessionUser.username}_Name");
            _memoryCache.Remove($"{sessionUser.username}_UserDetails");
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
            
            _memoryCache.Remove($"{sessionUser.username}_UserDetails");
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
            
            _memoryCache.Remove($"{sessionUser.username}_UserDetails");
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

            return Ok(response);
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

            // delete cache key of the admin
            var redisCache = _redis.GetDatabase();
            await redisCache.KeyDeleteAsync("allUsersList");
            
            return Ok(result);
        }


        [HttpGet("view/photo")]
        public async Task<IActionResult> GetUserPhotoAsync()
        {
            var serializedUserObj = HttpContext.Session.GetString("UserSession");
            if (serializedUserObj == null)
            {
                return Unauthorized("You should login first to view your photo");
            }

            var sessionUser = JsonSerializer.Deserialize<User>(serializedUserObj);
            if (sessionUser == null)
            {
                return Unauthorized("User Session is Expired. Please log in first.");
            }
            
            var userPhotoCacheKey = $"{sessionUser.username}_Photo";

            if (!_memoryCache.TryGetValue(userPhotoCacheKey, out string cachedUserPhoto))
            {
                var userId = await _usersService.GetIdByUsername(sessionUser.username);

                cachedUserPhoto = await _usersService.GetUserPhoto(userId);
                
                var cacheEntryOptions = new MemoryCacheEntryOptions()
                    .SetSlidingExpiration(TimeSpan.FromHours(3));

                _memoryCache.Set(userPhotoCacheKey, cachedUserPhoto, cacheEntryOptions);
            }

            return Ok(cachedUserPhoto);
        }

        [HttpGet("view/name")]
        public async Task<IActionResult> GetUserNameAsync()
        {
            var serializedUserObj = HttpContext.Session.GetString("UserSession");
            if (serializedUserObj == null)
            {
                return Unauthorized("You should login first to view your name");
            }

            var sessionUser = JsonSerializer.Deserialize<User>(serializedUserObj);
            if (sessionUser == null)
            {
                return Unauthorized("User Session is Expired. Please log in first.");
            }
            
            var userNameCacheKey = $"{sessionUser.username}_Name";

            if (!_memoryCache.TryGetValue(userNameCacheKey, out string cachedUserName))
            {
                var userId = await _usersService.GetIdByUsername(sessionUser.username);

                cachedUserName = await _usersService.GetNameUser(userId);
                
                var cacheEntryOptions = new MemoryCacheEntryOptions()
                    .SetSlidingExpiration(TimeSpan.FromHours(3));

                _memoryCache.Set(userNameCacheKey, cachedUserName, cacheEntryOptions);
            }

            return Ok(cachedUserName);
        }

        [HttpGet("view/details")]
        public async Task<IActionResult> GetUserDetailsAsync()
        {
            var serializedUserObj = HttpContext.Session.GetString("UserSession");
            if (serializedUserObj == null)
            {
                return Unauthorized("You should login first to view your personal details");
            }

            var sessionUser = JsonSerializer.Deserialize<User>(serializedUserObj);
            if (sessionUser == null)
            {
                return Unauthorized("User Session is Expired. Please log in first.");
            }
            
            var userDetailsCacheKey = $"{sessionUser.username}_UserDetails";
            
            if (!_memoryCache.TryGetValue(userDetailsCacheKey, out User? cachedUserDetails))
            {
                var userId = await _usersService.GetIdByUsername(sessionUser.username);

                cachedUserDetails = await _usersService.GetUserById(userId);
                if (cachedUserDetails == null)
                {
                    return NotFound("User not found.");
                }

                var cacheEntryOptions = new MemoryCacheEntryOptions()
                    .SetSlidingExpiration(TimeSpan.FromHours(3));

                _memoryCache.Set(userDetailsCacheKey, cachedUserDetails, cacheEntryOptions);
            }
            
            return Ok(cachedUserDetails);
        }
    }
}