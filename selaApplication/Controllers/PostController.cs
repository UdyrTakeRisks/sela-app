using Microsoft.AspNetCore.Mvc;
using selaApplication.Dtos;
using selaApplication.Models;
using selaApplication.Services.Post;
using selaApplication.Services.User;
using System.Text.Json;
using Microsoft.Extensions.Caching.Distributed;
using Microsoft.Extensions.Caching.Memory;

namespace selaApplication.Controllers;

[ApiController]
[Route("api/[controller]")]
public class PostController : ControllerBase
{
    // should do CRUD operations on posts
    // follow the prototype logic to cope with it

    private readonly IPostService _postsService;
    private readonly IUserService _usersService;
    private readonly IDistributedCache _distributedCache;
    private readonly IMemoryCache _memoryCache;
    private const string OrganizationCacheKey = "OrganizationPosts";
    private const string IndividualsCacheKey = "IndividualPosts";

    public PostController(IPostService postsService, IUserService usersService, IDistributedCache distributedCache, IMemoryCache memoryCache)
    {
        _postsService = postsService;
        _usersService = usersService;
        _distributedCache = distributedCache;
        _memoryCache = memoryCache;
    }

    [HttpGet("health")]
    public Task<IActionResult> CheckAppHealth()
    {
        var jsonData = new { Health = "Good", SELA = "Working", Type = "Post" };
        return Task.FromResult<IActionResult>(new JsonResult(jsonData));
    }

    [HttpPost("user")]
    public async Task<IActionResult> CreateUserPostAsync(PostDto dto)
    {
        // retrieve user sessions
        var serializedUserObj = HttpContext.Session.GetString("UserSession");

        if (serializedUserObj == null)
        {
            return Unauthorized("You should login first to add a post");
        }

        var sessionUser = JsonSerializer.Deserialize<User>(serializedUserObj);
        if (sessionUser == null)
            return Unauthorized("User Session is Expired please log in first");

        Console.WriteLine("User Username: " + sessionUser.username + " User Pass: " + sessionUser.password);

        var post = new Post
        {
            ImageUrLs = dto.ImageUrLs,
            name = dto.name,
            Type = dto.Type,
            tags = dto.tags,
            title = dto.title,
            description = dto.description,
            providers = dto.providers,
            about = dto.about,
            socialLinks = dto.socialLinks
        };

        var userId = await _usersService.GetIdByUsername(sessionUser.username);
        var res = await _postsService.AddUserPost(post, userId);

        
        await _distributedCache.RemoveAsync(OrganizationCacheKey);
        _memoryCache.Remove(IndividualsCacheKey);
        _memoryCache.Remove($"{sessionUser.username}_Posts");
        
        return Ok(res);
    }

    [HttpPost("admin")]
    public async Task<IActionResult> CreateAdminPostAsync(PostDto dto)
    {
        // retrieve admin sessions
        var serializedAdminObj = HttpContext.Session.GetString("AdminSession");

        if (serializedAdminObj == null)
        {
            return Unauthorized("You should login first to add a post");
        }

        var sessionAdmin = JsonSerializer.Deserialize<Admin>(serializedAdminObj);
        if (sessionAdmin == null)
            return Unauthorized("Admin Session is Expired please log in first");

        Console.WriteLine("Admin Username: " + sessionAdmin.username + " Admin Pass: " + sessionAdmin.password);

        var post = new Post
        {
            ImageUrLs = dto.ImageUrLs,
            name = dto.name,
            Type = dto.Type,
            tags = dto.tags,
            title = dto.title,
            description = dto.description,
            providers = dto.providers,
            about = dto.about,
            socialLinks = dto.socialLinks
        };

        var response = await _postsService.AddAdminPost(post);
        
        await _distributedCache.RemoveAsync(OrganizationCacheKey);
        _memoryCache.Remove(IndividualsCacheKey);
        // _memoryCache.Remove($"{sessionAdmin.username}_Posts");
        
        return Ok(response);
    }

    [HttpGet("view/all/orgs")]
    public async Task<IActionResult> ViewOrganizationPostsAsync()
    {
        // handle caching results with timeouts to enhance the performance
        var cachedPosts = await _distributedCache.GetStringAsync(OrganizationCacheKey);
        if (cachedPosts == null)
        {
            var post = new Post { Type = PostType.Organization };
            var retrievedPosts = await _postsService.GetPosts(post);

            cachedPosts = JsonSerializer.Serialize(retrievedPosts);

            var cacheEntryOptions = new DistributedCacheEntryOptions()
                .SetSlidingExpiration(TimeSpan.FromHours(3));

            await _distributedCache.SetStringAsync(OrganizationCacheKey, cachedPosts, cacheEntryOptions);
        }

        var posts = JsonSerializer.Deserialize<IEnumerable<Post>>(cachedPosts);
        
        return Ok(posts);
    }

    [HttpGet("view/all/individuals")]
    public async Task<IActionResult> ViewIndividualPostsAsync()
    {
        // handle caching results with timeouts to enhance the performance
        if (!_memoryCache.TryGetValue(IndividualsCacheKey, out IEnumerable<Post> cachedPosts))
        {
            var post = new Post { Type = PostType.Individual };
            cachedPosts = await _postsService.GetPosts(post);

            var cacheEntryOptions = new MemoryCacheEntryOptions()
                .SetSlidingExpiration(TimeSpan.FromHours(3));

            _memoryCache.Set(IndividualsCacheKey, cachedPosts, cacheEntryOptions);
        }
        
        return Ok(cachedPosts);
    }

    [HttpPut("update/{id}")]
    public async Task<IActionResult> EditPostAsync(int id, PostDto dto)
    {
        if (dto == null) // the required annotations already handle this
        {
            return BadRequest("Invalid post data.");
        }

        var serializedUserObj = HttpContext.Session.GetString("UserSession");
        if (serializedUserObj == null)
        {
            return Unauthorized("You should login first to edit a post");
        }

        var sessionUser = JsonSerializer.Deserialize<User>(serializedUserObj);
        if (sessionUser == null)
        {
            return Unauthorized("User Session is Expired. Please log in first.");
        }

        var userId = await _usersService.GetIdByUsername(sessionUser.username);
        //var post = await _postsService.GetPostById(id); // is this matters ? redundant database hit, use id directly in update

        // just create a new post obj and pass it to the update
        var post = new Post
        {
            // Update the post with the new data from dto
            Type = dto.Type,
            title = dto.title,
            description = dto.description,
            about = dto.about,
            socialLinks = dto.socialLinks,

            ImageUrLs = dto.ImageUrLs,
            name = dto.name,
            tags = dto.tags,
            providers = dto.providers
        };
        // Log the post data for debugging
        Console.WriteLine($"Updating Post: {JsonSerializer.Serialize(post)}");

        var result = await _postsService.UpdatePost(post, id, userId);

        await _distributedCache.RemoveAsync(OrganizationCacheKey);
        _memoryCache.Remove(IndividualsCacheKey);
        _memoryCache.Remove($"{sessionUser.username}_Posts");
        
        return Ok(result);
    }


    [HttpDelete("delete/{id}")]
    public async Task<IActionResult> RemovePostAsync(int id)
    {
        var serializedUserObj = HttpContext.Session.GetString("UserSession");
        if (serializedUserObj == null)
        {
            return Unauthorized("You should login first to delete a post");
        }

        var sessionUser = JsonSerializer.Deserialize<User>(serializedUserObj);
        if (sessionUser == null)
        {
            return Unauthorized("User Session is Expired. Please log in first.");
        }

        var userId = await _usersService.GetIdByUsername(sessionUser.username);

        var res = await _postsService.DeletePost(id, userId);

        await _distributedCache.RemoveAsync(OrganizationCacheKey);
        _memoryCache.Remove(IndividualsCacheKey);
        _memoryCache.Remove($"{sessionUser.username}_Posts");
        
        return Ok(res);
    }

    [HttpGet("myPosts")]
    public async Task<ActionResult> ShowMyPostsAsync()
    {
        // Retrieve user session
        var serializedUserObj = HttpContext.Session.GetString("UserSession");
        if (serializedUserObj == null)
            return Unauthorized("Please login first to see your posts.");

        var sessionUser = JsonSerializer.Deserialize<User>(serializedUserObj);
        if (sessionUser == null)
            return Unauthorized("Invalid user session. Please login again.");

        Console.WriteLine("User Username: " + sessionUser.username + " User Pass: " + sessionUser.password);

        var userPostsCacheKey = $"{sessionUser.username}_Posts";

        if (!_memoryCache.TryGetValue(userPostsCacheKey, out IEnumerable<Post> cachedUserPosts))
        {
            var userId = await _usersService.GetIdByUsername(sessionUser.username);
            cachedUserPosts = await _postsService.ShowPostsById(userId);
            
            var cacheEntryOptions = new MemoryCacheEntryOptions()
                .SetSlidingExpiration(TimeSpan.FromHours(1));

            _memoryCache.Set(userPostsCacheKey, cachedUserPosts, cacheEntryOptions);
        }

        var enumerablePosts = cachedUserPosts.ToList();
        if (!enumerablePosts.Any())
            return NotFound("No posts found for this user.");

        var response = new
        {
            sessionUser.username,
            posts = enumerablePosts
        };

        return Ok(response);
    }

    [HttpGet("search")]
    public async Task<IActionResult> SearchPosts([FromQuery] string query, [FromQuery] string filterBy)
    {
        try
        {
            Console.WriteLine("query value: " + query + " filterby value: " + filterBy);
            var posts = await _postsService.SearchPosts(query, filterBy);
            if (posts == null || !posts.Any())
            {
                return NotFound("No posts found.");
            }
            return Ok(posts);
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Internal server error: {ex.Message}");
        }
    }

    [HttpPost("save/{postId:int}")]
    public async Task<IActionResult> SaveUserPostAsync(int postId)
    {
        var serializedUserObj = HttpContext.Session.GetString("UserSession");
        if (serializedUserObj == null)
        {
            return Unauthorized("You should login first to save a post");
        }

        var sessionUser = JsonSerializer.Deserialize<User>(serializedUserObj);
        if (sessionUser == null)
        {
            return Unauthorized("User Session is Expired. Please log in first.");
        }

        var userId = await _usersService.GetIdByUsername(sessionUser.username);
        var postName = await _postsService.GetPostNameById(postId);

        var response = await _postsService.SavePost(userId, postId, sessionUser.username, postName);

        _memoryCache.Remove($"{sessionUser.username}_SavedPosts");
        return Ok(response);
    }

    [HttpDelete("un-save/{postId:int}")]
    public async Task<IActionResult> UnSaveUserPostAsync(int postId)
    {
        var serializedUserObj = HttpContext.Session.GetString("UserSession");
        if (serializedUserObj == null)
        {
            return Unauthorized("You should login first to un save a post");
        }

        var sessionUser = JsonSerializer.Deserialize<User>(serializedUserObj);
        if (sessionUser == null)
        {
            return Unauthorized("User Session is Expired. Please log in first.");
        }

        var userId = await _usersService.GetIdByUsername(sessionUser.username);

        var response = await _postsService.UnSavePost(userId, postId);
        
        _memoryCache.Remove($"{sessionUser.username}_SavedPosts");
        return Ok(response);
    }

    [HttpGet("view/saved")]
    public async Task<IActionResult> RetrieveUserSavedPostsAsync()
    {
        var serializedUserObj = HttpContext.Session.GetString("UserSession");
        if (serializedUserObj == null)
        {
            return Unauthorized("You should login first to view saved posts");
        }
        
        var sessionUser = JsonSerializer.Deserialize<User>(serializedUserObj);
        if (sessionUser == null)
        {
            return Unauthorized("User Session is Expired. Please log in first.");
        }

        var userSavedPostsCacheKey = $"{sessionUser.username}_SavedPosts";

        if (!_memoryCache.TryGetValue(userSavedPostsCacheKey, out IEnumerable<Post> cachedUserSavedPosts))
        {
            var userId = await _usersService.GetIdByUsername(sessionUser.username);
            cachedUserSavedPosts = await _postsService.GetSavedPostsById(userId);
            
            var cacheEntryOptions = new MemoryCacheEntryOptions()
                .SetSlidingExpiration(TimeSpan.FromHours(3));

            _memoryCache.Set(userSavedPostsCacheKey, cachedUserSavedPosts, cacheEntryOptions);
        }
        
        var enumerablePosts = cachedUserSavedPosts.ToList();
        if (!enumerablePosts.Any())
            return NotFound("No saved posts found for this user.");

        return Ok(enumerablePosts);
    }

    [HttpPost("review/{postId:int}")]
    public async Task<IActionResult> ReviewPostAsync(int postId, ReviewPostDto dto)
    {
        var serializedUserObj = HttpContext.Session.GetString("UserSession");
        if (serializedUserObj == null)
        {
            return Unauthorized("You should login first to write a review to the post");
        }

        var sessionUser = JsonSerializer.Deserialize<User>(serializedUserObj);
        if (sessionUser == null)
        {
            return Unauthorized("User Session is Expired. Please log in first.");
        }

        // create review
        var userId = await _usersService.GetIdByUsername(sessionUser.username);
        var postName = await _postsService.GetPostNameById(postId);
        if (dto.rating is < 0 or > 5)
            return BadRequest("Please Rate Post from 1 to 5");

        var review = new Review
        {
            post_id = postId,
            user_id = userId,
            username = sessionUser.username,
            postName = postName,
            description = dto.description,
            rating = dto.rating
        };

        var response = await _postsService.CreateReview(review);

        _memoryCache.Remove($"{postId}_PostReviews");
        return Ok(response);
    }

    [HttpDelete("un-review/{postId:int}")]
    public async Task<IActionResult> UnReviewPostAsync(int postId)
    {
        var serializedUserObj = HttpContext.Session.GetString("UserSession");
        if (serializedUserObj == null)
        {
            return Unauthorized("You should login first to un review the post");
        }

        var sessionUser = JsonSerializer.Deserialize<User>(serializedUserObj);
        if (sessionUser == null)
        {
            return Unauthorized("User Session is Expired. Please log in first.");
        }

        // delete review
        var userId = await _usersService.GetIdByUsername(sessionUser.username);
        var response = await _postsService.DeleteReview(postId, userId);

        _memoryCache.Remove($"{postId}_PostReviews");
        return Ok(response);
    }

    [HttpGet("view/reviews/{postId:int}")]
    public async Task<IActionResult> ShowPostReviewsAsync(int postId)
    {
        var postReviewsCacheKey = $"{postId}_PostReviews";

        if (!_memoryCache.TryGetValue(postReviewsCacheKey, out IEnumerable<Review> cachedPostReviews))
        {
            // get post reviews
            cachedPostReviews = await _postsService.GetPostReviewsById(postId);
            
            var cacheEntryOptions = new MemoryCacheEntryOptions()
                .SetSlidingExpiration(TimeSpan.FromHours(3));

            _memoryCache.Set(postReviewsCacheKey, cachedPostReviews, cacheEntryOptions);
        }
        
        var enumerablePosts = cachedPostReviews.ToList();
        if (!enumerablePosts.Any())
            return NotFound("No post reviews found for this post.");

        return Ok(enumerablePosts);
    }

    [HttpGet("view/overall/rating")]
    public async Task<IActionResult> ShowPostRatingAsync([FromQuery] int postId)
    {
        // get overall rating for a post
        var response = await _postsService.GetPostRatingById(postId);

        var result = new
        {
            overallRating = response
        };
        return Ok(result);
    }

    [HttpGet("is-saved/{postId:int}")]
    public async Task<IActionResult> CheckIfPostIsSavedAsync(int postId)
    {
        var serializedUserObj = HttpContext.Session.GetString("UserSession");
        if (serializedUserObj == null)
        {
            return Unauthorized("You should login first to check if the post is saved");
        }

        var sessionUser = JsonSerializer.Deserialize<User>(serializedUserObj);
        if (sessionUser == null)
        {
            return Unauthorized("User Session is Expired. Please log in first.");
        }

        var userId = await _usersService.GetIdByUsername(sessionUser.username);
        var response = await _postsService.isSavedPost(userId, postId);

        return Ok(response);
    }
}
