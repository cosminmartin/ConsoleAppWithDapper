using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleAppWithDapper.Models
{
    internal class PostMessage
    {
        public Guid PostId { get; set; }
        public Guid MessageId { get; set; }
    }
}
