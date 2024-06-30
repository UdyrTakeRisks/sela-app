using System.Text;
using Microsoft.AspNetCore.Mvc;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using selaApplication.Dtos;
using selaApplication.Models;
using System.Text.Json;
using selaApplication.Services.Notification;
using selaApplication.Services.User;

namespace selaApplication.Controllers;

[ApiController]
[Route("api/[controller]")]
public class NotificationController : ControllerBase
{
    private readonly INotificationService _notificationService;
    private readonly IUserService _userService;

    public NotificationController(INotificationService notificationService, IUserService userService)
    {
        _notificationService = notificationService;
        _userService = userService;
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

        var userId = await _userService.GetIdByUsername(sessionUser.username);

        var notifications = await _notificationService.GetAllNotifications(userId);
        var enumerable = notifications.ToList();
        if (!enumerable.Any())
        {
            return BadRequest("No Notifications Found");
        }
        
        return Ok(enumerable);
    }
}