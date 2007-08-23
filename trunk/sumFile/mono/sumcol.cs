/* The Great Computer Language Shootout
   http://shootout.alioth.debian.org/

   contributed by Isaac Gouy
*/

using System;
using System.IO;

class SumCol
{
   static void Main(){
      int sum = 0;

      using (StreamReader r = new StreamReader(Console.OpenStandardInput())){
         string line;
         while ((line = r.ReadLine()) != null) sum += Int32.Parse(line);
      }
      Console.WriteLine(sum);
   }
}

