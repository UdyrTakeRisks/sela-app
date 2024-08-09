namespace selaApplication.Persistence;

using Npgsql;

public class PostgresConnection : IDisposable
{
    // private readonly string _connectionString = "Host=127.0.0.1;Port=5432;Username=ahmed;Database=seladb";
    private readonly string _connectionString = "User Id=postgres.ihaofykdrzgouxpitrvi;Password=9fg1GZEKxJYwQ6EH;Server=aws-0-eu-central-1.pooler.supabase.com;Port=5432;Database=postgres;";
    public NpgsqlConnection _connection;
    
    public void Connect()
    {
        _connection = new NpgsqlConnection(_connectionString);
        _connection.Open();
    }

    public void Disconnect()
    {
        _connection?.Close();
        _connection?.Dispose();
    }

    public void Dispose()
    {
        Disconnect();
    }
}