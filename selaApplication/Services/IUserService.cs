using selaApplication.Models;

namespace selaApplication.Services;

public interface IUserService
{
    Task<string> AddUser(User user);
    Task<User?> GetByUsername(string username); 
} 