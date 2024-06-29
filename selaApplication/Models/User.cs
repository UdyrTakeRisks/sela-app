using System.ComponentModel.DataAnnotations;

namespace selaApplication.Models;

public class User
{
    public string? userPhoto { get; set; }
    [MaxLength(255)] public string username { get; set; }
    [MaxLength(255)] public string name { get; set; }
    [MaxLength(255)] public string email { get; set; }
    public string phoneNumber { get; set; }
    [MaxLength(255)] public string password { get; set; }
}
