using System.ComponentModel.DataAnnotations;

namespace selaApplication.Dtos;

public class UserDto
{
    public string username { get; set; }
    public string name { get; set; }
    public string email { get; set; }
    public long phoneNumber { get; set; } 
    public string password { get; set; }
} 