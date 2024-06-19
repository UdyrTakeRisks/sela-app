using selaApplication.Services;
using selaApplication.Services.Admin;
using selaApplication.Services.Post;
using selaApplication.Services.User;

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

            builder.Services.AddCors();

            builder.Services.AddSwaggerGen();

            builder.Services.AddDistributedMemoryCache();

            builder.Services.AddSession(options =>
            {
                options.IdleTimeout = TimeSpan.FromDays(1); // ?
                options.Cookie.HttpOnly = true;
                options.Cookie.IsEssential = true;
            });

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

            app.MapControllers();

            app.Run();
        }
    }
}