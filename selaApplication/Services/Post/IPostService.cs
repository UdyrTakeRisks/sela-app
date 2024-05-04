namespace selaApplication.Services.Post;

public interface IPostService
{
    Task<string> AddAdminPost(Models.Post post);
    Task<string> AddUserPost(Models.Post post, int userId);
    Task<IEnumerable<Models.Post>> GetPosts(Models.Post post);
    Task<IEnumerable<Models.Post>> ShowPostsById(int userId);
}