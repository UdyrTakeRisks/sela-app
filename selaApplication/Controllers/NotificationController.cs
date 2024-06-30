using System.Text;
using Microsoft.AspNetCore.Mvc;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using selaApplication.Dtos;
using selaApplication.Models;
using System.Text.Json;

namespace selaApplication.Controllers;

[ApiController]
[Route("api/[controller]")]
public class NotificationController : ControllerBase
{
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
    public IActionResult SendWelcomeNotification(WelcomeNotificationDto dto)
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
    
}