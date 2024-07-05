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

                const string updatePostsSql = "UPDATE posts SET user_id = NULL WHERE user_id = @user_id";
                await using var deletePostsCommand = new NpgsqlCommand(updatePostsSql, connector._connection);
                deletePostsCommand.Parameters.AddWithValue("user_id", userId);
                await deletePostsCommand.ExecuteNonQueryAsync();
                
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

        public async Task<string> UpdateUserPhoto(int userId, string userPhoto)
        {
            try
            {
                using var connector = new PostgresConnection();
                connector.Connect();

                const string sql =
                    "UPDATE users SET user_photo = @user_photo " +
                    "WHERE user_id = @user_id";

                await using var command = new NpgsqlCommand(sql, connector._connection);

                command.Parameters.AddWithValue("user_photo", userPhoto);
                command.Parameters.AddWithValue("user_id", userId);

                var rowsAffected = await command.ExecuteNonQueryAsync();

                if (rowsAffected > 0)
                    return "User Photo has been updated successfully";

                return "No user found with this user id";
            }
            catch (Exception ex)
            {
                // Log the exception details for debugging
                Console.WriteLine($"An error occurred while updating user account: {ex.Message}");
                Console.WriteLine($"Stack Trace: {ex.StackTrace}");

                // Return an error message to the caller
                return $"An error occurred while updating the user account: {ex.Message}";
            }
        }

        public async Task<string> UpdateNameById(int userId, string newName)
        {
            try
            {
                using var connector = new PostgresConnection();
                connector.Connect();

                const string sql =
                    "UPDATE users SET name = @name " +
                    "WHERE user_id = @user_id";

                await using var command = new NpgsqlCommand(sql, connector._connection);

                command.Parameters.AddWithValue("name", newName);
                command.Parameters.AddWithValue("user_id", userId);

                var rowsAffected = await command.ExecuteNonQueryAsync();
                if (rowsAffected > 0)
                    return "Name has been updated successfully";

                return "No user found with this user id";
            }
            catch (Exception ex)
            {

                Console.WriteLine($"An error occurred while updating name of user: {ex.Message} ");
                Console.WriteLine($"Stack Trace: {ex.StackTrace}");

                return $"An error occurred while updating the name of the user: {ex.Message}";
            }
        }

        public async Task<string> UpdateEmailById(int userId, string newEmail)
        {
            try
            {
                using var connector = new PostgresConnection();
                connector.Connect();

                const string sql =
                    "UPDATE users SET email = @email " +
                    "WHERE user_id = @user_id";

                await using var command = new NpgsqlCommand(sql, connector._connection);
                command.Parameters.AddWithValue("email", newEmail);
                command.Parameters.AddWithValue("user_id", userId);

                var rowsAffected = await command.ExecuteNonQueryAsync();
                if (rowsAffected > 0)
                    return "Email has been updated successfully";

                return "No user found with this user id";


            }
            catch (Exception ex)
            {

                Console.WriteLine($"An error occurred while updating email of user: {ex.Message}");
                Console.WriteLine($"Stack Trace: {ex.StackTrace}");

                return $"An error occurred while updating the email of the user: {ex.Message}";
            }
        }

        public async Task<string> UpdatePhoneNumberById(int userId, string newPhoneNumber)
        {
            try
            {
                var connector = new PostgresConnection();
                connector.Connect();

                const string sql =
                    "UPDATE users SET phone_number = @phone_number " +
                    "WHERE user_id = @user_id";
                await using var command = new NpgsqlCommand(sql, connector._connection);
                command.Parameters.AddWithValue("phone_number", newPhoneNumber);
                command.Parameters.AddWithValue("user_id", userId);

                var rowsAffected = await command.ExecuteNonQueryAsync();
                if (rowsAffected > 0)
                    return "Phone number has been updated successfully";

                return "No user found with this user id";
            }
            catch (Exception ex)
            {

                Console.WriteLine($"An error occurred while updating phone number: {ex.Message}");
                Console.WriteLine($"Stack Trace: {ex.StackTrace}");

                return $"An error occurred while updating the phone number of the user: {ex.Message}";
            }
        }

        public async Task<string> UpdatePasswordById(int userId, string newPassword)
        {
            try
            {
                var connector = new PostgresConnection();
                connector.Connect();

                const string sql =
                    "UPDATE users SET password = @password " +
                    "WHERE user_id = @user_id";
                await using var command = new NpgsqlCommand(sql, connector._connection);
                command.Parameters.AddWithValue("password", newPassword);
                command.Parameters.AddWithValue("user_id", userId);

                var rowsAffected = await command.ExecuteNonQueryAsync();
                if (rowsAffected > 0)
                    return "Password has been updated successfully";

                return "No user found with this user id";

            }
            catch (Exception ex)
            {

                Console.WriteLine($"An error occurred while updating password: {ex.Message}");
                Console.WriteLine($"Stack Trace: {ex.StackTrace}");

                return $"An error occurred while updating the password of the user: {ex.Message}";

            }
        }

        public async Task<string> GetPasswordById(int userId)
        {
            try
            {
                using var connector = new PostgresConnection();
                connector.Connect();

                const string sql =
                    "SELECT password FROM users " +
                    "WHERE user_id = @user_id";

                await using var command = new NpgsqlCommand(sql, connector._connection);
                command.Parameters.AddWithValue("user_id", userId);

                var password = await command.ExecuteScalarAsync();
                return password?.ToString();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"An error occurred while retrieving password: {ex.Message}");
                Console.WriteLine($"Stack Trace: {ex.StackTrace}");
                return ("An error occurred while retrieving the password of the user: {ex.Message}");
            }
        }

        public async Task<string> GetUserPhoto(int userId)
        {
            try
            {
                using var connector = new PostgresConnection();
                connector.Connect();

                const string sql =
                    "SELECT user_photo FROM users " +
                    "WHERE user_id = @user_id";

                await using var command = new NpgsqlCommand(sql, connector._connection);
                command.Parameters.AddWithValue("user_id", userId);

                var userPhoto = await command.ExecuteScalarAsync();
                return userPhoto?.ToString();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"An error occurred while retrieving user photo: {ex.Message}");
                Console.WriteLine($"Stack Trace: {ex.StackTrace}");
                return ("An error occurred while retrieving the user photo of the user: {ex.Message}");
            }
        }

        public async Task<string> GetNameUser(int userId)
        {

            try
            {
                using var connector = new PostgresConnection();
                connector.Connect();

                const string sql =
                    "SELECT name FROM users " +
                    "WHERE user_id = @user_id";

                await using var command = new NpgsqlCommand(sql, connector._connection);
                command.Parameters.AddWithValue("user_id", userId);

                var name = await command.ExecuteScalarAsync();
                return name?.ToString();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"An error occurred while retrieving user name: {ex.Message}");
                Console.WriteLine($"Stack Trace: {ex.StackTrace}");
                return ("An error occurred while retrieving the user name of the user: {ex.Message}");
            }
        }

        public async Task<Models.User?> GetUserById(int userId)
        {
            try
            {
                using var connector = new PostgresConnection();
                connector.Connect();

                const string sql =
                    "SELECT * FROM users " +
                    "WHERE user_id = @user_id";

                await using var command = new NpgsqlCommand(sql, connector._connection);
                command.Parameters.AddWithValue("user_id", userId);

                await using var reader = command.ExecuteReader();
                if (await reader.ReadAsync())
                {
                    var user_id = reader.GetInt32(reader.GetOrdinal("user_id"));
                    var userName = reader.GetString(reader.GetOrdinal("username"));
                    var name = reader.GetString(reader.GetOrdinal("name"));
                    var email = reader.GetString(reader.GetOrdinal("email"));
                    var phoneNumber = reader.GetString(reader.GetOrdinal("phone_number"));
                    
                    return new Models.User
                    {
                        user_id = user_id,
                        username = userName,
                        name = name,
                        email = email,
                        phoneNumber = phoneNumber
                    };
                }
                
                return null;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"An error occurred while retrieving user: {ex.Message}");
                Console.WriteLine($"Stack Trace: {ex.StackTrace}");
                return null;
            }
        }



    }
}