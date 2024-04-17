using System.Security.Cryptography;
using System.Text;

namespace selaApplication.Helpers;

public static class UserHelper
{
    public static string HashPassword(string password)
    { 
        using var sha256Hash = SHA256.Create();
        var bytes = sha256Hash.ComputeHash(Encoding.UTF8.GetBytes(password));

        var builder = new StringBuilder();
        foreach (var b in bytes)
        {
            builder.Append(b.ToString("x2"));
        }
        return builder.ToString();
    }
    
}