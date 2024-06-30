namespace selaApplication.Services.Notification;

public interface INotificationService
{
    Task<string> AddNotification(Models.Notification notification);
    Task<IEnumerable<Models.Notification>> GetAllNotifications(int userId);
     
}