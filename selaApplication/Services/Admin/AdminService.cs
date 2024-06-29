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

                // const string deletePostsSql = "DELETE FROM posts WHERE user_id = @user_id";
                // await using var deletePostsCommand = new NpgsqlCommand(deletePostsSql, connector._connection);
                // deletePostsCommand.Parameters.AddWithValue("user_id", userId);
                // await deletePostsCommand.ExecuteNonQueryAsync();

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
        
    }
}
