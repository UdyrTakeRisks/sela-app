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
            using var connector = new PostgresConnection();
            connector.Connect();

            const string sql =
                "INSERT INTO posts (imageurls, name, post_type, tags, title, description, providers, about, social_links)" +
                " VALUES (@imageURLs, @name, @post_type, @tags, @title, @description, @providers, @about, @social_links)";

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
            await command.ExecuteNonQueryAsync();

            return "Post has been added successfully";
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

            return "Post has been added Successfully";
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

    public async Task<string> GetPostNameById(int postId)
    {
        try
        {
            using var connector = new PostgresConnection();
            connector.Connect();

            const string sql = "SELECT name FROM posts WHERE post_id = @post_id";

            await using var command = new NpgsqlCommand(sql, connector._connection);
            command.Parameters.AddWithValue("post_id", postId);

            await using var reader = command.ExecuteReader();

            if (!reader.Read()) return "No post is found with this id";

            var postName = reader.GetString(reader.GetOrdinal("name"));
            return postName;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"An error occured while getting the post name: {ex.Message}");

            return "An error occured while getting the post name";
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
                    post_id = reader.GetInt32(reader.GetOrdinal("post_id")),
                    type = reader.GetString(reader.GetOrdinal("post_type")),
                    ImageUrLs = reader.GetFieldValue<string[]>(reader.GetOrdinal("imageurls")),
                    name = reader.GetString(reader.GetOrdinal("name")),
                    tags = reader.GetFieldValue<string[]>(reader.GetOrdinal("tags")),
                    title = reader.GetString(reader.GetOrdinal("title")),
                    description = reader.GetString(reader.GetOrdinal("description")),
                    providers = reader.GetFieldValue<string[]>(reader.GetOrdinal("providers")),
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
                    post_id = reader.GetInt32(reader.GetOrdinal("post_id")),
                    type = reader.GetString(reader.GetOrdinal("post_type")),
                    ImageUrLs = reader.GetFieldValue<string[]>(reader.GetOrdinal("imageurls")),
                    name = reader.GetString(reader.GetOrdinal("name")),
                    tags = reader.GetFieldValue<string[]>(reader.GetOrdinal("tags")),
                    title = reader.GetString(reader.GetOrdinal("title")),
                    description = reader.GetString(reader.GetOrdinal("description")),
                    providers = reader.GetFieldValue<string[]>(reader.GetOrdinal("providers")),
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

    public async Task<string> UpdatePost(Models.Post post, int postId, int userId)
    {
        try
        {
            using var connector = new PostgresConnection();
            connector.Connect();

            const string sql =
                "UPDATE posts SET imageurls = @imageURLs, name = @name, post_type = @post_type, tags = @tags, title = @title, " +
                "description = @description, providers = @providers, about = @about, social_links = @social_links " +
                "WHERE post_id = @postId AND user_id = @userId";

            await using var command = new NpgsqlCommand(sql, connector._connection);

            // Log parameters for debugging
            Console.WriteLine(
                $"Parameters: imageURLs={post.ImageUrLs}, name={post.name}, post_type={post.Type.ToString()}, " +
                $"tags={post.tags}, title={post.title}, description={post.description}, providers={post.providers}, " +
                $"about={post.about}, social_links={post.socialLinks}, postId={post.post_id}, userId={userId}");

            command.Parameters.AddWithValue("imageURLs", post.ImageUrLs ?? (object)DBNull.Value);
            command.Parameters.AddWithValue("name", post.name);
            command.Parameters.AddWithValue("post_type", post.Type.ToString());
            command.Parameters.AddWithValue("tags", post.tags ?? (object)DBNull.Value);
            command.Parameters.AddWithValue("title", post.title ?? (object)DBNull.Value);
            command.Parameters.AddWithValue("description", post.description ?? (object)DBNull.Value);
            command.Parameters.AddWithValue("providers", post.providers ?? (object)DBNull.Value);
            command.Parameters.AddWithValue("about", post.about ?? (object)DBNull.Value);
            command.Parameters.AddWithValue("social_links", post.socialLinks ?? (object)DBNull.Value);
            command.Parameters.AddWithValue("postId", postId);
            command.Parameters.AddWithValue("userId", userId);

            int rowsAffected = await command.ExecuteNonQueryAsync();

            if (rowsAffected > 0)
            {
                return "Post has been updated successfully";
            }

            return "No post found with the provided id and user id";
        }
        catch (Exception ex)
        {
            // Log the exception details for debugging
            Console.WriteLine($"An error occurred while updating the post: {ex.Message}");
            Console.WriteLine($"Stack Trace: {ex.StackTrace}");

            // Return an error message to the caller
            return $"An error occurred while updating the post: {ex.Message}";
        }
    }


    public async Task<string> DeletePost(int postId, int userId)
    {
        try
        {
            // Connection string should ideally be stored in a configuration file for security and maintainability
            using var connector = new PostgresConnection();
            connector.Connect();

            const string sql = "DELETE FROM posts WHERE post_id = @post_id AND user_id = @user_id";

            await using var command = new NpgsqlCommand(sql, connector._connection);

            // Adding parameters with their appropriate values
            command.Parameters.AddWithValue("post_id", postId);
            command.Parameters.AddWithValue("user_id",
                userId); // Assuming post.UserId is the identifier of the user who owns the post

            // Execute the command asynchronously
            var rowsAffected = await command.ExecuteNonQueryAsync();

            if (rowsAffected > 0)
            {
                return "Post has been deleted successfully";
            }

            return "No post found to delete";
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
                    post_id = reader.GetInt32(reader.GetOrdinal("post_id")),
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

    public async Task<IEnumerable<Models.Post>> SearchPosts(string query, string filterBy)
    {
        try
        {
            using var connector = new PostgresConnection();
            connector.Connect();

            string sql;
            if (filterBy.ToLower() == "name")
            {
                sql = @"
                SELECT * FROM posts 
                WHERE LOWER(name) LIKE LOWER(@query)";
            }
            else if (filterBy.ToLower() == "tag")
            {
                sql = @"
                SELECT * FROM posts 
                WHERE EXISTS (
                    SELECT 1 FROM unnest(tags) AS tag WHERE LOWER(tag) LIKE LOWER(@query)
                )";
            }
            else
            {
                throw new ArgumentException("Invalid filterBy value.");
            }

            var posts = new List<Models.Post>();

            await using var command = new NpgsqlCommand(sql, connector._connection);
            command.Parameters.AddWithValue("query", "%" + query + "%");

            await using var reader = await command.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                var fetchedPost = new Models.Post
                {
                    post_id = reader.GetInt32(reader.GetOrdinal("post_id")),
                    ImageUrLs = reader.GetFieldValue<string[]>(reader.GetOrdinal("imageurls")),
                    name = reader.GetString(reader.GetOrdinal("name")),
                    tags = reader.GetFieldValue<string[]>(reader.GetOrdinal("tags")),
                    title = reader.GetString(reader.GetOrdinal("title")),
                    description = reader.GetString(reader.GetOrdinal("description")),
                    providers = reader.GetFieldValue<string[]>(reader.GetOrdinal("providers")),
                    about = reader.GetString(reader.GetOrdinal("about")),
                    socialLinks = reader.GetString(reader.GetOrdinal("social_links"))
                };
                posts.Add(fetchedPost);
            }
            if (posts == null)
            {
                Console.WriteLine($"inside search posts there are no posts");
            }

            return posts;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"An error occurred while searching for posts: {ex.Message}");
            return null;
        }
    }


    public async Task<string> SavePost(int userId, int postId, string username, string postName)
    {
        try
        {
            using var connector = new PostgresConnection();
            connector.Connect();

            const string sql =
                "INSERT INTO save_posts (user_id, post_id, username, post_name)" +
                " VALUES (@userId, @postId, @username, @post_name)";

            await using var command = new NpgsqlCommand(sql, connector._connection);

            command.Parameters.AddWithValue("userId", userId);
            command.Parameters.AddWithValue("postId", postId);
            command.Parameters.AddWithValue("username", username);
            command.Parameters.AddWithValue("post_name", postName);
            await command.ExecuteNonQueryAsync();

            return "Post has been Saved Successfully";
        }
        catch (Exception ex)
        {
            // Log the exception or handle it as needed
            // For example, you can log it to a file, send an email notification, or return an error message to the caller

            // Example of logging the exception to the console
            Console.WriteLine($"An error occurred while saving the post: {ex.Message}");

            // Return an error message to the caller
            return "An error occurred while saving the post";
        }
    }

    public async Task<string> UnSavePost(int userId, int postId)
    {
        try
        {
            // Connection string should ideally be stored in a configuration file for security and maintainability
            using var connector = new PostgresConnection();
            connector.Connect();

            const string sql = "DELETE FROM save_posts WHERE post_id = @post_id AND user_id = @user_id";

            await using var command = new NpgsqlCommand(sql, connector._connection);

            // Adding parameters with their appropriate values
            command.Parameters.AddWithValue("post_id", postId);
            command.Parameters.AddWithValue("user_id", userId);

            // Execute the command asynchronously
            var rowsAffected = await command.ExecuteNonQueryAsync();

            if (rowsAffected > 0)
            {
                return "Saved Post has been removed successfully";
            }

            return "No Saved post with this id is found to remove";
        }
        catch (Exception ex)
        {
            // Log the exception details (this should be done to a proper logging framework in a real application)
            Console.WriteLine($"An error occurred while removing the saved post: {ex.Message}");

            // Return a generic error message to the caller
            return "An error occurred while removing the saved post";
        }
    }

    public async Task<IEnumerable<Models.Post>> GetSavedPostsById(int userId)
    {
        try
        {
            using var connector = new PostgresConnection();
            connector.Connect();

            const string sql = @"

                                SELECT p.post_id, p.imageurls, p.name, p.post_type, p.tags, p.title, p.description,
                                       p.providers, p.about, p.social_links
                                FROM save_posts sp 
                                JOIN posts p
                                ON sp.post_id = p.post_id
                                WHERE sp.user_id = @user_id";

            var posts = new List<Models.Post>();

            await using var command = new NpgsqlCommand(sql, connector._connection);
            command.Parameters.AddWithValue("user_id", userId);

            await using var reader = await command.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                var fetchedPost = new Models.Post
                {
                    post_id = reader.GetInt32(reader.GetOrdinal("post_id")),
                    // Type = (PostType)reader.GetInt32(reader.GetOrdinal("post_type")),
                    ImageUrLs = reader.GetFieldValue<string[]>(reader.GetOrdinal("imageurls")),
                    name = reader.GetString(reader.GetOrdinal("name")),
                    type = reader.GetString(reader.GetOrdinal("post_type")),
                    tags = reader.GetFieldValue<string[]>(reader.GetOrdinal("tags")),
                    title = reader.GetString(reader.GetOrdinal("title")),
                    description = reader.GetString(reader.GetOrdinal("description")),
                    providers = reader.GetFieldValue<string[]>(reader.GetOrdinal("providers")),
                    about = reader.GetString(reader.GetOrdinal("about")),
                    socialLinks = reader.GetString(reader.GetOrdinal("social_links"))
                };
                posts.Add(fetchedPost);
            }

            return posts;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"An error occurred while getting the saved posts: {ex.Message}");

            return null;
        }
    }

    public async Task<string> CreateReview(Review review)
    {
        try
        {
            using var connector = new PostgresConnection();
            connector.Connect();

            const string sql =
                "INSERT INTO review_posts (post_id, user_id, username, post_name, description, rating)" +
                " VALUES (@postId, @userId, @username, @post_name, @description, @rating)";

            await using var command = new NpgsqlCommand(sql, connector._connection);

            command.Parameters.AddWithValue("postId", review.post_id);
            command.Parameters.AddWithValue("userId", review.user_id);
            command.Parameters.AddWithValue("username", review.username);
            command.Parameters.AddWithValue("post_name", review.postName);
            command.Parameters.AddWithValue("description", review.description);
            command.Parameters.AddWithValue("rating", review.rating);
            await command.ExecuteNonQueryAsync();

            return "Post has been Reviewed Successfully";
        }
        catch (Exception ex)
        {
            // Log the exception or handle it as needed
            // For example, you can log it to a file, send an email notification, or return an error message to the caller

            // Example of logging the exception to the console
            Console.WriteLine($"An error occurred while reviewing the post: {ex.Message}");

            // Return an error message to the caller
            return "An error occurred while reviewing the post";
        }
    }

    public async Task<string> DeleteReview(int postId, int userId)
    {
        try
        {
            // Connection string should ideally be stored in a configuration file for security and maintainability
            using var connector = new PostgresConnection();
            connector.Connect();

            const string sql = "DELETE FROM review_posts WHERE post_id = @post_id AND user_id = @user_id";

            await using var command = new NpgsqlCommand(sql, connector._connection);

            // Adding parameters with their appropriate values
            command.Parameters.AddWithValue("post_id", postId);
            command.Parameters.AddWithValue("user_id", userId);

            // Execute the command asynchronously
            var rowsAffected = await command.ExecuteNonQueryAsync();

            if (rowsAffected > 0)
            {
                return "Post Review has been removed successfully";
            }

            return "No post review with this id is found to remove";
        }
        catch (Exception ex)
        {
            // Log the exception details (this should be done to a proper logging framework in a real application)
            Console.WriteLine($"An error occurred while removing the post review: {ex.Message}");

            // Return a generic error message to the caller
            return "An error occurred while removing the post review";
        }
    }

    public async Task<IEnumerable<Review>> GetPostReviewsById(int postId)
    {
        try
        {
            using var connector = new PostgresConnection();
            connector.Connect();

            const string sql = "SELECT * FROM review_posts WHERE post_id = @post_id";

            var postReviews = new List<Review>();

            await using var command = new NpgsqlCommand(sql, connector._connection);
            command.Parameters.AddWithValue("post_id", postId);

            await using var reader = await command.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                var fetchedPostReviews = new Review
                {
                    username = reader.GetString(reader.GetOrdinal("username")),
                    description = reader.GetString(reader.GetOrdinal("description")),
                    rating = reader.GetFloat(reader.GetOrdinal("rating"))
                };
                postReviews.Add(fetchedPostReviews);
            }

            return postReviews;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"An error occurred while showing the post reviews: {ex.Message}");

            return null;
        }
    }

    public async Task<double> GetPostRatingById(int postId)

    {
        try
        {
            using var connector = new PostgresConnection();
            connector.Connect();

            const string sql = "SELECT AVG(rating) AS overall_rating FROM review_posts WHERE post_id = @post_id";

            await using var command = new NpgsqlCommand(sql, connector._connection);
            command.Parameters.AddWithValue("post_id", postId);

            await using var reader = await command.ExecuteReaderAsync();

            if (!await reader.ReadAsync())
                return 0.0;

            if (reader.IsDBNull(reader.GetOrdinal("overall_rating")))
                return 0.0;

            var overallRating = reader.GetDouble(reader.GetOrdinal("overall_rating"));

            return overallRating;

        }
        catch (Exception ex)
        {
            Console.WriteLine($"An error occurred while getting the post rating: {ex.Message}");

            return 0;
        }
    }

    public async Task<bool> isSavedPost(int userId, int postId)
    {

        try
        {
            using var connector = new PostgresConnection();
            connector.Connect();

            const string sql =
                "SELECT * FROM save_posts " +
                "WHERE user_id = @user_id AND post_id = @post_id";

            await using var command = new NpgsqlCommand(sql, connector._connection);
            command.Parameters.AddWithValue("user_id", userId);
            command.Parameters.AddWithValue("post_id", postId);

            await using var reader = command.ExecuteReader();
            return reader.Read();
        }
        catch (Exception ex)
        {
            Console.WriteLine($"An error occurred while checking if post is saved: {ex.Message}");
            Console.WriteLine($"Stack Trace: {ex.StackTrace}");
            return false;
        }
    }


}