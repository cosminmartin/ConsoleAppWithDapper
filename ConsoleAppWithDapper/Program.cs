using System.Configuration;
using System.Data.SqlClient;

namespace ConsoleAppWithDapper
{
    internal class Program
    {
        static void Main(string[] args)
        {
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConsoleAppWithDapper.Properties.Settings.SQLDatabase"].ConnectionString);

            using (conn)
            {
                conn.Open();
                Queries.GetUsers(conn);
            }
        }
    }
}
