using Npgsql;
using selaApplication.Persistence;

namespace selaApplication.Services.User
{
    public class UserService : IUserService
    {
        public async Task<string> AddUser(Models.User user)
        {
            try
            {
                using var connector = new PostgresConnection();
                connector.Connect();

                const string sql = "INSERT INTO users (username, name, email, phone_number, password)" +
                                   " VALUES (@username, @name, @email, @phoneNumber, @password)";

                await using var command = new NpgsqlCommand(sql, connector._connection);
                command.Parameters.AddWithValue("username", user.username);
                command.Parameters.AddWithValue("name", user.name);
                command.Parameters.AddWithValue("email", user.email);
                command.Parameters.AddWithValue("phoneNumber", user.phoneNumber);
                command.Parameters.AddWithValue("password", user.password);
                await command.ExecuteNonQueryAsync();

                return "User has been added successfully";
            }
            catch (Exception ex)
            {
                // Log the exception or handle it as needed
                // For example, you can log it to a file, send an email notification, or return an error message to the caller

                // Example of logging the exception to the console
                Console.WriteLine($"An error occurred while adding the user: {ex.Message}");

                // Return an error message to the caller
                return "An error occurred while adding the user";
            }
        }
        public async Task<Models.User?> GetByUsername(string username) //alter it to return a user obj
        {
            try
            {
                using var connector = new PostgresConnection();
                connector.Connect();

                const string sql = "SELECT * FROM users WHERE username = @username";

                await using var command = new NpgsqlCommand(sql, connector._connection);
                command.Parameters.AddWithValue("username", username);

                await using var reader = command.ExecuteReader();
                if (reader.Read())
                {
                    var userName = reader.GetString(reader.GetOrdinal("username"));
                    var password = reader.GetString(reader.GetOrdinal("password"));
                    return new Models.User
                    {
                        username = userName,
                        password = password 
                    };
                }

                return null; 
            }
            catch (Exception ex)
            {
                Console.WriteLine($"An error occurred while getting the user: {ex.Message}");
                
                return null;
            }
        }
        public async Task<int> GetIdByUsername(string username) 
        {
            try
            {
                using var connector = new PostgresConnection();
                connector.Connect();

                const string sql = "SELECT user_id FROM users WHERE username = @username";

                await using var command = new NpgsqlCommand(sql, connector._connection);
                command.Parameters.AddWithValue("username", username);

                await using var reader = command.ExecuteReader();
                if (reader.Read())
                {
                    var userId = reader.GetInt32(reader.GetOrdinal("user_id"));
                    return userId;
                }

                return -1; 
            }
            catch (Exception ex)
            {
                Console.WriteLine($"An error occurred while getting the user: {ex.Message}");
                
                return -1;
            }
        }
        
        public async Task<string> DeleteUser(int userId)
        {
            try
            {
                // Connection string should ideally be stored in a configuration file for security and maintainability
                using var connector = new PostgresConnection();
                connector.Connect();

                const string sql = "DELETE FROM users WHERE user_id = @user_id";

                await using var command = new NpgsqlCommand(sql, connector._connection);

                // Adding parameters with their appropriate values
                command.Parameters.AddWithValue("user_id", userId); 

                // Execute the command asynchronously
                int rowsAffected = await command.ExecuteNonQueryAsync();

                if (rowsAffected > 0)
                {
                    return "User has been removed successfully";
                }

                return "No user found to remove";
            }
            catch (Exception ex)
            {
                // Log the exception details (this should be done to a proper logging framework in a real application)
                Console.WriteLine($"An error occurred while removing the user: {ex.Message}");

                // Return a generic error message to the caller
                return "An error occurred while removing the user";
            }
        }
        
    }
}