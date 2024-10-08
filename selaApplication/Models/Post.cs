using System.Collections;
using System.Text.Json.Serialization;


namespace selaApplication.Models;

public class Post
{
    public int post_id { get; set; }
    public string[]? ImageUrLs { get; set; }
    public string name { get; set; }
    [JsonIgnore] public PostType Type { get; set; }
    public string type { get; set; }
    public string[]? tags { get; set; }
    public string title { get; set; }
    public string description { get; set; }
    public string[]? providers { get; set; }
    public string about { get; set; }
    public string socialLinks { get; set; }
    [JsonIgnore] public int UserId { get; set; }
}

public enum PostType
{
    Organization,
    Individual
}