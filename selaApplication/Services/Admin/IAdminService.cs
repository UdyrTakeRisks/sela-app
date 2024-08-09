using selaApplication.Dtos;

namespace selaApplication.Services.Admin
{
    public interface IAdminService
    {
        Task<bool> DeletePost(int postId);
        Task<bool> DeleteUser(int userId);
        Task<IEnumerable<Models.User>> GetAllUsers();
        Task<string> UpdatePosts(int postId, Models.Post post);
    }
}
