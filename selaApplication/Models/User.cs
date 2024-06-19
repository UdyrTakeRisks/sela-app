using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace selaApplication.Models;

public class User
{
    [MaxLength(255)] public string username { get; set; }
    [MaxLength(255)] public string name { get; set; }
    [MaxLength(255)] public string email { get; set; }
    public long phoneNumber { get; set; } 
    [MaxLength(255)] public string password { get; set; }
}
