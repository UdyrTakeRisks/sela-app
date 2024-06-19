using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace selaApplication.Models;

public class Admin
{
    [MaxLength(255)] public string username { get; set; }
    
    [MaxLength(255)] public string password { get; set; }
    
}