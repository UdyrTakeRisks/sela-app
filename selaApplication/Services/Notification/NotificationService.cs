using System.Data;
using Npgsql;
using selaApplication.Persistence;

namespace selaApplication.Services.Notification;

public class NotificationService : INotificationService
{
    public async Task<string> AddNotification(Models.Notification notification)
    {
        try
        {
            using var connector = new PostgresConnection();
            connector.Connect();

            const string sql =
                "INSERT INTO notifications (user_id, username, message)" +
                " VALUES (@userId, @username, @message)";

            await using var command = new NpgsqlCommand(sql, connector._connection);
            
            command.Parameters.AddWithValue("userId", notification.user_id);
            command.Parameters.AddWithValue("username", notification.username);
            command.Parameters.AddWithValue("message", notification.message);
            
            await command.ExecuteNonQueryAsync();

            return "Notification has been added Successfully";
        }
        catch (Exception ex)
        {
            
            // Example of logging the exception to the console
            Console.WriteLine($"An error occurred while adding the notification: {ex.Message}");

            // Return an error message to the caller
            return "An error occurred while adding the notification";
        }
    }

    public async Task<IEnumerable<Models.Notification>> GetAllNotifications(int userId)
    {
        try
        {
            using var connector = new PostgresConnection();
            connector.Connect();

            const string sql = "SELECT * FROM notifications WHERE user_id = @user_id";

            var notifications = new List<Models.Notification>();

            await using var command = new NpgsqlCommand(sql, connector._connection);
            command.Parameters.AddWithValue("user_id", userId);

            await using var reader = await command.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                var fetchedNotification = new Models.Notification
                {
                    user_id = reader.GetInt32(reader.GetOrdinal("user_id")),
                    username = reader.GetString(reader.GetOrdinal("username")),
                    message = reader.GetString(reader.GetOrdinal("message")),
                };
                
                notifications.Add(fetchedNotification);
            }

            return notifications;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"An error occurred while showing the post reviews: {ex.Message}");

            return null;
        }
    }
}