using Npgsql;
using selaApplication.Dtos;
using selaApplication.Models;
using selaApplication.Persistence;
using selaApplication.Services.Post;
namespace selaApplication.Services.Admin
{
    public class AdminService : IAdminService
    {

        private readonly IPostService _postService;


        public async Task<bool> DeletePost(int postId)
        {
            try
            {
                using var connector = new PostgresConnection();
                connector.Connect();

                const string sql = "DELETE FROM posts WHERE post_id = @post_id";
                await using var command = new NpgsqlCommand(sql, connector._connection);
                command.Parameters.AddWithValue("post_id", postId);
                await command.ExecuteNonQueryAsync();

                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"An error occurred while deleting the post: {ex.Message}");
                return false;
            }
        }

        public async Task<bool> DeleteUser(int userId)
        {
            try
            {
                using var connector = new PostgresConnection();
                connector.Connect();

                const string deletePostsSql = "DELETE FROM posts WHERE user_id = @user_id";
                await using var deletePostsCommand = new NpgsqlCommand(deletePostsSql, connector._connection);
                deletePostsCommand.Parameters.AddWithValue("user_id", userId);
                await deletePostsCommand.ExecuteNonQueryAsync();

                const string deleteUserSql = "DELETE FROM users WHERE user_id = @user_id";
                await using var deleteUserCommand = new NpgsqlCommand(deleteUserSql, connector._connection);
                deleteUserCommand.Parameters.AddWithValue("user_id", userId);
                await deleteUserCommand.ExecuteNonQueryAsync();

                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"An error occurred while deleting the user: {ex.Message}");
                return false;
            }
        }
    }
}
