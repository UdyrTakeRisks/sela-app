using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace selaApplication.Models;

public class Post
{
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public int Id { get; set; }
    
    public byte[] image { get; set; }
    public PostType Type { get; set; }  
    public string title { get; set; }
    public string description { get; set; }
    public string about { get; set; }
    public string socialLinks { get; set; }
}

public enum PostType
{
    Organization,
    Individual
}