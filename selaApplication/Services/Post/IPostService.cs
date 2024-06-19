namespace selaApplication.Services.Post;

using selaApplication.Models;
public interface IPostService
{
    Task<string> AddAdminPost(Models.Post post);
    Task<string> AddUserPost(Models.Post post, int userId);
    Task<string> DeletePost(Models.Post post);
    Task<Post> GetPostById(int id);
    Task<IEnumerable<Models.Post>> GetPosts(Models.Post post);
    Task<IEnumerable<Models.Post>> ShowPostsById(int userId);
    Task<string> UpdatePost(Models.Post post, int userId);
}