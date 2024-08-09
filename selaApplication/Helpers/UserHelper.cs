using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;

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

    public static bool ValidateUsername(string username)
    {
        return true;
    }

    public static bool ValidatePassword(string password)
    {
        return true;
    }

    public static bool ValidateEmail(string email)
    {
        if (string.IsNullOrWhiteSpace(email))
            return false;

        // Regular expression pattern for basic email validation
        const string pattern = @"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";

        var regex = new Regex(pattern);
        return regex.IsMatch(email);
    }

    public static bool ValidatePhoneNumber(string phoneNumber)
    {
        // Check if the phone number is null or its length is not 10
        if (string.IsNullOrEmpty(phoneNumber) || phoneNumber.Length != 10)
        {
            return false;
        }

        // Check if the phone number starts with the specified prefixes
        var prefix = phoneNumber.Substring(0, 2);
        if (prefix != "11" && prefix != "15" && prefix != "10" && prefix != "12")
        {
            return false;
        }

        // Check if all characters are digits
        foreach (char c in phoneNumber)
        {
            if (!char.IsDigit(c))
            {
                return false;
            }
        }

        // If all checks pass, the phone number is valid
        // example of valid phone number: 1095032345

        return true;
    }
    
    public static bool VerifyPassword(string password, string hashedPassword)
    {
        var hashedInputPassword = HashPassword(password);
        return hashedInputPassword == hashedPassword;
    }

}