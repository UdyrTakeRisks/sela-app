using Npgsql;
using selaApplication.Models;
using selaApplication.Persistence;

namespace selaApplication.Services.Post;
public class PostService : IPostService
{
    public async Task<string> AddAdminPost(Models.Post post)
    {
        try
        {
            // int typeValue = (int)Models.Post.Type.Organization;
            using var connector = new PostgresConnection();
            connector.Connect();

            const string sql = "INSERT INTO posts (post_type, title, description, about, social_links)" +
                               " VALUES (@post_type, @title, @description, @about, @social_links)";

            await using var command = new NpgsqlCommand(sql, connector._connection);
            command.Parameters.AddWithValue("post_type", post.Type.ToString());
            command.Parameters.AddWithValue("title", post.title);
            command.Parameters.AddWithValue("description", post.description);
            command.Parameters.AddWithValue("about", post.about);
            command.Parameters.AddWithValue("social_links", post.socialLinks);

            await command.ExecuteNonQueryAsync();

            return "post has been added successfully";
        }
        catch (Exception ex)
        {
            // Log the exception or handle it as needed
            // For example, you can log it to a file, send an email notification, or return an error message to the caller

            // Example of logging the exception to the console
            Console.WriteLine($"An error occurred while adding the post: {ex.Message}");

            // Return an error message to the caller
            return "An error occurred while adding the post";
        }
    }
    public async Task<string> AddUserPost(Models.Post post, int userId)
    {
        try
        {
            // int typeValue = (int)Models.Post.Type.Organization;
            using var connector = new PostgresConnection();
            connector.Connect();

            const string sql = "INSERT INTO posts (post_type, title, description, about, social_links, user_id)" +
                               " VALUES (@post_type, @title, @description, @about, @social_links, @user_id)";

            await using var command = new NpgsqlCommand(sql, connector._connection);
            command.Parameters.AddWithValue("post_type", post.Type.ToString());
            command.Parameters.AddWithValue("title", post.title);
            command.Parameters.AddWithValue("description", post.description);
            command.Parameters.AddWithValue("about", post.about);
            command.Parameters.AddWithValue("social_links", post.socialLinks);
            command.Parameters.AddWithValue("user_id", userId);
            await command.ExecuteNonQueryAsync();

            return "post has been added successfully";
        }
        catch (Exception ex)
        {
            // Log the exception or handle it as needed
            // For example, you can log it to a file, send an email notification, or return an error message to the caller

            // Example of logging the exception to the console
            Console.WriteLine($"An error occurred while adding the post: {ex.Message}");

            // Return an error message to the caller
            return "An error occurred while adding the post";
        }
    }

    public async Task<string> DeletePost(Models.Post post)
    {
        try
        {
            // Ensure that the post is valid
            if (post == null) throw new ArgumentNullException(nameof(post));
            if (post.Id <= 0) throw new ArgumentOutOfRangeException(nameof(post.Id));

            // Connection string should ideally be stored in a configuration file for security and maintainability
            using var connector = new PostgresConnection();
            connector.Connect();

            const string sql = @"
            DELETE FROM posts
            WHERE post_id = @post_id AND user_id = @user_id";

            await using var command = new NpgsqlCommand(sql, connector._connection);

            // Adding parameters with their appropriate values
            command.Parameters.AddWithValue("post_id", post.Id);
            command.Parameters.AddWithValue("user_id", post.UserId); // Assuming post.UserId is the identifier of the user who owns the post

            // Execute the command asynchronously
            int rowsAffected = await command.ExecuteNonQueryAsync();

            if (rowsAffected > 0)
            {
                return "Post has been deleted successfully";
            }
            else
            {
                return "No post found to delete";
            }
        }
        catch (Exception ex)
        {
            // Log the exception details (this should be done to a proper logging framework in a real application)
            Console.WriteLine($"An error occurred while deleting the post: {ex.Message}");

            // Return a generic error message to the caller
            return "An error occurred while deleting the post";
        }
    }


    public async Task<Models.Post> GetPostById(int id)
    {
        try
        {
            using var connector = new PostgresConnection();
            connector.Connect();

            const string sql = "SELECT * FROM posts WHERE post_id = @post_id";

            await using var command = new NpgsqlCommand(sql, connector._connection);
            command.Parameters.AddWithValue("post_id", id);

            await using var reader = await command.ExecuteReaderAsync();
            if (await reader.ReadAsync())
            {
                return new Models.Post
                {
                    Id = reader.GetInt32(reader.GetOrdinal("post_id")),
                    Type = Enum.Parse<PostType>(reader.GetString(reader.GetOrdinal("post_type"))),
                    title = reader.GetString(reader.GetOrdinal("title")),
                    description = reader.GetString(reader.GetOrdinal("description")),
                    about = reader.GetString(reader.GetOrdinal("about")),
                    socialLinks = reader.GetString(reader.GetOrdinal("social_links")),
                    UserId = reader.GetInt32(reader.GetOrdinal("user_id"))
                };
            }
            return null;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"An error occurred while getting the post: {ex.Message}");
            return null;
        }
    }


    public async Task<IEnumerable<Models.Post>> GetPosts(Models.Post post)
    {
        try
        {
            using var connector = new PostgresConnection();
            connector.Connect();

            const string sql = "SELECT * FROM posts WHERE post_type = @type";

            var posts = new List<Models.Post>();

            await using var command = new NpgsqlCommand(sql, connector._connection);
            command.Parameters.AddWithValue("type", post.Type.ToString());

            await using var reader = await command.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                var fetchedPost = new Models.Post
                {
                    // Id = reader.GetInt32(reader.GetOrdinal("Id")),
                    // Type = (PostType)reader.GetInt32(reader.GetOrdinal("post_type")),
                    title = reader.GetString(reader.GetOrdinal("title")),
                    description = reader.GetString(reader.GetOrdinal("description")),
                    about = reader.GetString(reader.GetOrdinal("about")),
                    socialLinks = reader.GetString(reader.GetOrdinal("social_links"))
                };
                posts.Add(fetchedPost);
            }

            return posts;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"An error occurred while getting the posts: {ex.Message}");

            return null;
        }
    }

    public async Task<IEnumerable<Models.Post>> ShowPostsById(int userId)
    {
        try
        {
            using var connector = new PostgresConnection();
            connector.Connect();

            const string sql = "SELECT * FROM posts WHERE user_id = @user_id";

            var posts = new List<Models.Post>();

            await using var command = new NpgsqlCommand(sql, connector._connection);
            command.Parameters.AddWithValue("user_id", userId);

            await using var reader = await command.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                var fetchedPost = new Models.Post
                {
                    // Id = reader.GetInt32(reader.GetOrdinal("Id")),
                    // Type = (PostType)reader.GetInt32(reader.GetOrdinal("post_type")),
                    title = reader.GetString(reader.GetOrdinal("title")),
                    description = reader.GetString(reader.GetOrdinal("description")),
                    about = reader.GetString(reader.GetOrdinal("about")),
                    socialLinks = reader.GetString(reader.GetOrdinal("social_links"))
                };
                posts.Add(fetchedPost);
            }

            return posts;
        }



        catch (Exception ex)
        {
            Console.WriteLine($"An error occurred while showing the posts: {ex.Message}");

            return null;
        }


    }
    public async Task<string> UpdatePost(Models.Post post, int userId)
    {
        try
        {
            // Ensure that the post and userId are valid
            if (post == null) throw new ArgumentNullException(nameof(post));
            if (userId <= 0) throw new ArgumentOutOfRangeException(nameof(userId));

            // Connection string should ideally be stored in a configuration file for security and maintainability
            using var connector = new PostgresConnection();
            connector.Connect();


            const string sql = @"
            UPDATE posts
            SET 
                post_type = @post_type,
                title = @title,
                description = @description,
                about = @about,
                social_links = @social_links
            WHERE 
                user_id = @user_id AND
                post_id = @post_id";

            await using var command = new NpgsqlCommand(sql, connector._connection);

            // Adding parameters with their appropriate values
            command.Parameters.AddWithValue("post_type", post.Type.ToString());
            command.Parameters.AddWithValue("title", post.title);
            command.Parameters.AddWithValue("description", post.description);
            command.Parameters.AddWithValue("about", post.about);
            command.Parameters.AddWithValue("social_links", post.socialLinks);
            command.Parameters.AddWithValue("user_id", userId);
            command.Parameters.AddWithValue("post_id", post.Id); // Assuming post.Id is the identifier for the post

            // Execute the command asynchronously
            int rowsAffected = await command.ExecuteNonQueryAsync();

            if (rowsAffected > 0)
            {
                return "Post has been updated successfully";
            }
            else
            {
                return "No post found to update";
            }
        }
        catch (Exception ex)
        {
            // Log the exception details (this should be done to a proper logging framework in a real application)
            Console.WriteLine($"An error occurred while updating the post: {ex.Message}");

            // Return a generic error message to the caller
            return "An error occurred while updating the post";
        }

    }


}