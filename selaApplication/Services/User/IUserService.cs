namespace selaApplication.Services.User;

public interface IUserService
{
    Task<string> AddUser(Models.User user);
    Task<Models.User?> GetByUsername(string username);
    Task<int> GetIdByUsername(string username);

    Task<string> GetPasswordById(int userId);

    Task<string> DeleteUser(int userId);
    Task<string> UpdateUserPhoto(int userId, string userPhoto);

    Task<string> UpdateNameById(int userId, string newName);
    Task<string> UpdateEmailById(int userId, string newEmail);

    Task<string> UpdatePhoneNumberById(int userId, string newPhoneNumber);

    Task<string> UpdatePasswordById(int userId, string newPassword);

}