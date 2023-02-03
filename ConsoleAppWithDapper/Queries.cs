
using System.Data.SqlClient;
using Dapper;
using ConsoleAppWithDapper.Models;

namespace ConsoleAppWithDapper
{
    internal static class Queries
    {
        public static void GetUsers(SqlConnection conn)
        {
            Console.WriteLine(MessageConstants.SelectAllUsers);

            var sqlSelectAllUsers = "SELECT * FROM Users";
            var users = conn.Query<User>(sqlSelectAllUsers);

            foreach (User user in users)
            {
                Console.WriteLine(user.FirstName + " " + user.LastName);
            }
            Console.ReadLine();
        }
    }
}
