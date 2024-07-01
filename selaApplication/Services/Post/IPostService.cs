namespace selaApplication.Services.Post;

using selaApplication.Models;

public interface IPostService
{
    Task<string> AddAdminPost(Post post);
    Task<string> AddUserPost(Post post, int userId);
    Task<IEnumerable<Post>> GetPosts(Post post);
    Task<IEnumerable<Post>> ShowPostsById(int userId);
    Task<Post> GetPostById(int id);
    Task<string> DeletePost(int postId, int userId);
    Task<IEnumerable<Post>> SearchPosts(string searchQuery);
    Task<string> UpdatePost(Models.Post post, int postId, int userId);
    Task<string> GetPostNameById(int postId);
    Task<string> SavePost(int userId, int postId, string username, string postName);
    Task<string> UnSavePost(int userId, int postId);
    Task<IEnumerable<Post>> GetSavedPostsById(int userId);
    Task<string> CreateReview(Review review);
    Task<string> DeleteReview(int postId, int userId);
    Task<IEnumerable<Review>> GetPostReviewsById(int postId);
    Task<double> GetPostRatingById(int postId);
    Task<bool> isSavedPost(int userId, int postId);

}
