using System.Text.Json.Serialization;

namespace selaApplication.Models;

public class Notification
{
    [JsonIgnore] public int user_id { get; set; }
    [JsonIgnore] public string username { get; set; }
    public string message { get; set; }
    
}