using Microsoft.AspNetCore.Authentication.JwtBearer;
using selaApplication.Services;
using selaApplication.Services.Admin;
using selaApplication.Services.Notification;
using selaApplication.Services.Post;
using selaApplication.Services.User;
using StackExchange.Redis;
    
namespace selaApplication
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.

            builder.Services.AddControllers();
            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            builder.Services.AddEndpointsApiExplorer();

            builder.Services.AddScoped<IUserService, UserService>(); //dip, maintains state

            builder.Services.AddScoped<IAdminService, AdminService>(); //dip, maintains state

            builder.Services.AddScoped<IPostService, PostService>(); //dip, maintains state

            builder.Services.AddScoped<INotificationService, NotificationService>(); //dip, maintains state
            
            builder.Services.AddCors();

            builder.Services.AddSwaggerGen();
            
            builder.Services.AddSession(options =>
            {
                options.IdleTimeout = TimeSpan.FromDays(1); // ?
                options.Cookie.HttpOnly = true;
                options.Cookie.IsEssential = true;
            });
            
            builder.Services.AddAuthentication(options =>
            {
                options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
            }).AddJwtBearer();

            // builder.Services.AddResponseCaching();

            builder.Services.AddMemoryCache();

            builder.Services.AddDistributedMemoryCache();

            const string redisConnectionString = "redis-13244.c302.asia-northeast1-1.gce.redns.redis-cloud.com:13244,password=2wWuipPfjnm1QCrBHCWXsHjFREq3iUMm";
            builder.Services.AddSingleton<IConnectionMultiplexer>(ConnectionMultiplexer.Connect(redisConnectionString));
            
            var app = builder.Build();

            // Configure the HTTP request pipeline.
            // if (app.Environment.IsDevelopment())
            // {
            app.UseSwagger();
            app.UseSwaggerUI();
            // }

            app.UseHttpsRedirection();

            app.UseAuthorization();

            app.UseCors(c => c.AllowAnyHeader().AllowAnyMethod().AllowAnyOrigin());

            app.UseSession();

            app.UseAuthentication();
            app.UseAuthorization();
            
            app.MapControllers();
            
            // app.UseResponseCaching();
            
            app.Run();
        }
    }
}