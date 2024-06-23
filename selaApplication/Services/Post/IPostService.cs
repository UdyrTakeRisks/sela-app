namespace selaApplication.Services.Post;

using selaApplication.Models;

public interface IPostService
{
    Task<string> AddAdminPost(Models.Post post);
    Task<string> AddUserPost(Models.Post post, int userId);
    Task<IEnumerable<Models.Post>> GetPosts(Models.Post post);
    Task<IEnumerable<Models.Post>> ShowPostsById(int userId);
    Task<Post> GetPostById(int id);
    Task<string> DeletePost(int postId, int userId);
    Task<string> UpdatePost(Models.Post post, int postId, int userId);
}