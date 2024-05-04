using System.ComponentModel.DataAnnotations;
using selaApplication.Models;

namespace selaApplication.Dtos;

public class PostDto
{
    [Required(ErrorMessage = "The Post type field is required.")]
    public PostType Type { get; set; }

    [Required(ErrorMessage = "The Title field is required.")]
    public string title { get; set; }

    [Required(ErrorMessage = "The Description field is required.")]
    public string description { get; set; }

    public string about { get; set; }
    public string socialLinks { get; set; }
}