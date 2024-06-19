using Npgsql;
using selaApplication.Persistence;

namespace selaApplication.Services.Post;

public class PostService : IPostService
{
    public async Task<string> AddAdminPost(Models.Post post) // behind
    {
        try
        {
            // int typeValue = (int)Models.Post.Type.Organization;
            using var connector = new PostgresConnection();
            connector.Connect();

            const string sql = "INSERT INTO posts (name, post_type, title, description, about, social_links)" +
                               " VALUES (@name, @post_type, @title, @description, @about, @social_links)";

            await using var command = new NpgsqlCommand(sql, connector._connection);
            command.Parameters.AddWithValue("name", post.name);
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

            const string sql =
                "INSERT INTO posts (imageurls, name, post_type, tags, title, description, providers, about, social_links, user_id)" +
                " VALUES (@imageURLs, @name, @post_type, @tags, @title, @description, @providers, @about, @social_links, @user_id)";

            await using var command = new NpgsqlCommand(sql, connector._connection);

            command.Parameters.AddWithValue("imageURLs", post.ImageUrLs);
            command.Parameters.AddWithValue("name", post.name);
            command.Parameters.AddWithValue("post_type", post.Type.ToString());
            command.Parameters.AddWithValue("tags", post.tags);
            command.Parameters.AddWithValue("title", post.title);
            command.Parameters.AddWithValue("description", post.description);
            command.Parameters.AddWithValue("providers", post.providers);
            command.Parameters.AddWithValue("about", post.about);
            command.Parameters.AddWithValue("social_links", post.socialLinks);
            command.Parameters.AddWithValue("user_id", userId);
            await command.ExecuteNonQueryAsync();

            return "post has been added Successfully";
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
                    ImageUrLs = reader.GetFieldValue<string[]>(reader.GetOrdinal("imageurls")), // not sure
                    name = reader.GetString(reader.GetOrdinal("name")),
                    tags = reader.GetFieldValue<string[]>(reader.GetOrdinal("tags")) , // not sure
                    title = reader.GetString(reader.GetOrdinal("title")),
                    description = reader.GetString(reader.GetOrdinal("description")),
                    providers = reader.GetFieldValue<string[]>(reader.GetOrdinal("providers")) , // not sure
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
}