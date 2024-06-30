using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace selaApplication.Models;

public class User
{
    public int user_id { get; set; }
    public string? userPhoto { get; set; }
    [MaxLength(255)] public string username { get; set; }
    [MaxLength(255)] public string name { get; set; }
    [MaxLength(255)] public string email { get; set; }
    public string phoneNumber { get; set; }
    [MaxLength(255)][JsonIgnore] public string password { get; set; }
}
