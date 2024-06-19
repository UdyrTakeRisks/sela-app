namespace selaApplication.Services.User;

public interface IUserService
{
    Task<string> AddUser(Models.User user);
    Task<Models.User?> GetByUsername(string username);
    Task<int> GetIdByUsername(string username);
} 