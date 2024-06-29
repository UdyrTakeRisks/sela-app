using System.Text.Json.Serialization;

namespace selaApplication.Models;

public class ReviewPost
{
    [JsonIgnore]
    public int post_id { get; set; }
    
    [JsonIgnore]
    public int user_id { get; set; }
     
    public string username { get; set; }
    
    [JsonIgnore]
    public string postName { get; set; }

    public string? description { get; set; }
    
    public double rating { get; set; }
    
}