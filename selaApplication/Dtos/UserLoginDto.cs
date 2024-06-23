using System.ComponentModel.DataAnnotations;

namespace selaApplication.Dtos;

public class UserLoginDto
{
    [Required(ErrorMessage = "The username field is required.")]
    public string username { get; set; }

    [Required(ErrorMessage = "The password field is required.")]
    public string password { get; set; }
}