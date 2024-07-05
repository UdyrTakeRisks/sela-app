using Npgsql;
using selaApplication.Persistence;
namespace selaApplication.Services.Admin
{
    public class AdminService : IAdminService
    {

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

                const string updatePostsSql = "UPDATE posts SET user_id = NULL WHERE user_id = @user_id";
                await using var deletePostsCommand = new NpgsqlCommand(updatePostsSql, connector._connection);
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

        public async Task<IEnumerable<Models.User>> GetAllUsers()
        {
            try
            {
                using var connector = new PostgresConnection();
                connector.Connect();

                const string sql = "SELECT * FROM users";

                var users = new List<Models.User>();

                await using var command = new NpgsqlCommand(sql, connector._connection);

                await using var reader = await command.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    var fetchedUser = new Models.User
                    {
                        user_id = reader.GetInt32(reader.GetOrdinal("user_id")),
                        // userPhoto = reader.GetString(reader.GetOrdinal("user_photo")),
                        username = reader.GetString(reader.GetOrdinal("username")),
                        name = reader.GetString(reader.GetOrdinal("name")),
                        email = reader.GetString(reader.GetOrdinal("email"))
                    };
                    users.Add(fetchedUser);
                }

                return users;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"An error occurred while getting users: {ex.Message}");

                return null;
            }
        }

        public async Task<string> UpdatePosts(int postId, Models.Post post)
        {
            try
            {
                using var connector = new PostgresConnection();
                connector.Connect();

                const string sql =
                    "UPDATE posts SET imageurls = @imageURLs, name = @name, post_type = @post_type, tags = @tags, title = @title, " +
                    "description = @description, providers = @providers, about = @about, social_links = @social_links " +
                    "WHERE post_id = @postId";

                await using var command = new NpgsqlCommand(sql, connector._connection);

                // Log parameters for debugging
                Console.WriteLine(
                    $"Parameters: imageURLs={post.ImageUrLs}, name={post.name}, post_type={post.Type.ToString()}, " +
                    $"tags={post.tags}, title={post.title}, description={post.description}, providers={post.providers}, " +
                    $"about={post.about}, social_links={post.socialLinks}, postId={post.post_id}");

                command.Parameters.AddWithValue("imageURLs", post.ImageUrLs ?? (object)DBNull.Value);
                command.Parameters.AddWithValue("name", post.name);
                command.Parameters.AddWithValue("post_type", post.Type.ToString());
                command.Parameters.AddWithValue("tags", post.tags ?? (object)DBNull.Value);
                command.Parameters.AddWithValue("title", post.title ?? (object)DBNull.Value);
                command.Parameters.AddWithValue("description", post.description ?? (object)DBNull.Value);
                command.Parameters.AddWithValue("providers", post.providers ?? (object)DBNull.Value);
                command.Parameters.AddWithValue("about", post.about ?? (object)DBNull.Value);
                command.Parameters.AddWithValue("social_links", post.socialLinks ?? (object)DBNull.Value);
                command.Parameters.AddWithValue("postId", postId);

                int rowsAffected = await command.ExecuteNonQueryAsync();

                if (rowsAffected > 0)
                {
                    return "Post has been updated successfully";
                }

                return "No post found with the provided id";
            }
            catch (Exception ex)
            {
                // Log the exception details for debugging
                Console.WriteLine($"An error occurred while updating the post: {ex.Message}");
                Console.WriteLine($"Stack Trace: {ex.StackTrace}");

                // Return an error message to the caller
                return $"An error occurred while updating the post: {ex.Message}";
            }
        }
        
        
    }
}

