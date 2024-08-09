using System.Text;
using Microsoft.AspNetCore.Mvc;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using selaApplication.Dtos;
using selaApplication.Models;
using System.Text.Json;
using selaApplication.Services.Notification;
using selaApplication.Services.User;
using StackExchange.Redis;

namespace selaApplication.Controllers;

[ApiController]
[Route("api/[controller]")]
public class NotificationController : ControllerBase
{
    private readonly INotificationService _notificationService;
    private readonly IUserService _userService;
    private readonly IConnectionMultiplexer _redis;
    
    public NotificationController(INotificationService notificationService, IUserService userService, IConnectionMultiplexer redis)
    {
        _notificationService = notificationService;
        _userService = userService;
        _redis = redis;
    }

    [HttpGet("health")]
    public IActionResult CheckAppHealth()
    {
        var jsonData = new
        {
            Health = "Good",
            SELA = "Working",
            Type = "Notification"
        };
        return Ok(jsonData);
    }

    [HttpPost("send/welcome-msg")]
    public IActionResult SendWelcomeNotification(NotificationDto dto)
    {
        var factory = new ConnectionFactory()
        {
            HostName = "hummingbird.rmq.cloudamqp.com",
            UserName = "pvstjptf",
            Password = "yCbuh4PFDj-9ad7k-crMtlrZsohCdDvW",
            VirtualHost = "pvstjptf"
        };
        using var connection = factory.CreateConnection();
        using var channel = connection.CreateModel();

        channel.QueueDeclare(queue: "welcome-notification",
            durable: false,
            exclusive: false,
            autoDelete: false,
            arguments: null);

        var welcomeMessage = dto.message;
        var body = Encoding.UTF8.GetBytes(welcomeMessage);

        channel.BasicPublish(exchange: string.Empty,
            routingKey: "welcome-notification",
            basicProperties: null,
            body: body);

        return Ok("Welcome Message has been sent successfully to the Queue.");
    }

    [HttpGet("receive/welcome-msg")]
    public IActionResult ReceiveWelcomeNotification()
    {
        var serializedUserObj = HttpContext.Session.GetString("UserSession");
        if (serializedUserObj == null)
        {
            return Unauthorized("You should login first to view your notification");
        }

        var sessionUser = JsonSerializer.Deserialize<User>(serializedUserObj);
        if (sessionUser == null)
        {
            return Unauthorized("User Session is Expired. Please log in first.");
        }

        var factory = new ConnectionFactory()
        {
            HostName = "hummingbird.rmq.cloudamqp.com",
            UserName = "pvstjptf",
            Password = "yCbuh4PFDj-9ad7k-crMtlrZsohCdDvW",
            VirtualHost = "pvstjptf"
        };
        using var connection = factory.CreateConnection();
        using var channel = connection.CreateModel();

        channel.QueueDeclare(queue: "welcome-notification",
            durable: false,
            exclusive: false,
            autoDelete: false,
            arguments: null);

        var result = channel.BasicGet(queue: "welcome-notification",
            autoAck: true);

        if (result == null)
        {
            return NotFound("No messages in the queue.");
        }

        var body = result.Body.ToArray();
        var welcomeMessage = Encoding.UTF8.GetString(body);
        
        return Ok(welcomeMessage);
    }

    [HttpPost("add")]
    public async Task<IActionResult> AddNotification(NotificationDto dto)
    {
        var serializedUserObj = HttpContext.Session.GetString("UserSession");
        if (serializedUserObj == null)
        {
            return Unauthorized("You should login first to add notification");
        }

        var sessionUser = JsonSerializer.Deserialize<User>(serializedUserObj);
        if (sessionUser == null)
        {
            return Unauthorized("User Session is Expired. Please log in first.");
        }
        
        //store the notification in database to retrieve it anytime
        var userId = await _userService.GetIdByUsername(sessionUser.username);
        var notification = new Notification
        {
            user_id = userId,
            username = sessionUser.username,
            message = dto.message
        };

        var resultFromDb = await _notificationService.AddNotification(notification);

        // remove cache
        var redisCache = _redis.GetDatabase();
        await redisCache.KeyDeleteAsync($"{sessionUser.username}_Notifications");
        
        var response = new
        {
            response = resultFromDb
        };

        return Ok(response);
    }
    
    
    [HttpGet("show/all")]
    public async Task<IActionResult> ReceiveAllNotifications()
    {
        var serializedUserObj = HttpContext.Session.GetString("UserSession");
        if (serializedUserObj == null)
        {
            return Unauthorized("You should login first to view all your notifications");
        }

        var sessionUser = JsonSerializer.Deserialize<User>(serializedUserObj);
        if (sessionUser == null)
        {
            return Unauthorized("User Session is Expired. Please log in first.");
        }

        var allNotificationsCacheKey = $"{sessionUser.username}_Notifications";
        
        var redisCache = _redis.GetDatabase();
        var cachedNotifications = await redisCache.StringGetAsync(allNotificationsCacheKey);
        if (cachedNotifications.IsNullOrEmpty)
        {
            var userId = await _userService.GetIdByUsername(sessionUser.username);

            var notificationsInDb = await _notificationService.GetAllNotifications(userId);
            var enumerableNotifications = notificationsInDb.ToList();
            if (!enumerableNotifications.Any())
                return BadRequest("No Notifications Found");
            
            var serializedNotifications = JsonSerializer.Serialize(enumerableNotifications);
            await redisCache.StringSetAsync(allNotificationsCacheKey, serializedNotifications, TimeSpan.FromHours(1));

            return Ok(enumerableNotifications);
        }

        var notifications = JsonSerializer.Deserialize<IEnumerable<Notification>>(cachedNotifications);
        return Ok(notifications);
    }
}