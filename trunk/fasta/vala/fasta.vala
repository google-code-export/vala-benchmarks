/* The Great Computer Language Shootout
   http://shootout.alioth.debian.org/

   contributed by Clément David
*/
using GLib;

public class Fasta : Object {

	static int main(string[] args)
	{
		Fasta.MakeCumulative (HomoSapiens);
		Fasta.MakeCumulative (IUB);
		
		int n = (args.length > 0)?args[1].to_int():1000;
		
		Fasta.MakeRepeatFasta ("ONE", "Homo sapiens alu", ALU.skip, n*2);
		Fasta.MakeRandomFasta ("TWO", "IUB ambiguity codes", IUB, n*3);
		Fasta.MakeRandomFasta ("THREE", "Homo sapiens frequency", HomoSapiens, n*5);
		
		return 0;
	}

	// Pseudo random generator
	const int IM = 139968;
	const int IA = 3877;
	const int IC = 29573;
	static int seed = 42;
	
	static double random (double max)
	{
		return max * ((seed = (seed * IA + IC) % IM) * (1.0 / IM));
	}
	
	
	// Weighted selection from alphabet
	
	static string ALU =
		"GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG" +
		"GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA" +
		"CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT" +
		"ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA" +
		"GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG" +
		"AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC" +
		"AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA";

	struct Frequency {
		public char c;
		public double p;
	}
	
	static Frequency[] IUB = {
			 {'a', 0.27}
			,{'c', 0.12}
			,{'g', 0.12}
			,{'t', 0.27}

			,{'B', 0.02}
			,{'D', 0.02}
			,{'H', 0.02}
			,{'K', 0.02}
			,{'M', 0.02}
			,{'N', 0.02}
			,{'R', 0.02}
			,{'S', 0.02}
			,{'V', 0.02}
			,{'W', 0.02}
			,{'Y', 0.02}
	};

	static Frequency[] HomoSapiens = {
			 {'a', 0.3029549426680}
			,{'c', 0.1979883004921}
			,{'g', 0.1975473066391}
			,{'t', 0.3015094502008}
	};

	
	static void MakeCumulative (Frequency[] a) {
		double cp = 0.0;
		for (int i=0; i < a.length; i++) {
			cp += a[i].p;
			a[i].p = cp;
		}
	}
	
	static char SelectRandom (Frequency[] a) {
		double r = random (1.0);

		for (int i=0 ; i < a.length ; i++)
			if (r < a[i].p)
				return a[i].c;

		return a[a.length-1].c;
	}
	
	const int LineLength = 60;
	static int index = 0;
	static char[] buf = new char[1024];
	
	static void MakeRandomFasta (string id, string desc, Frequency[] a, int n) {
		index = 0;
		int m = 0;

		string descStr = ">" + id + " " + desc + "\n";
		stdout.puts (descStr);

		while (n > 0) {
			m = n < LineLength ? n : LineLength;

			if (buf.length - index < m) {
				// FIXME : Change the index to index +1 or index -1
				stdout.puts (((string)buf).substring(0,index));
				index = 0;
			}

			for (int i = 0 ; i < m ; i++) {
				buf[index++] = SelectRandom (a);
			}

			buf[index++] = (char)'\n';
			n -= LineLength;
		}

		if (index != 0) 
			stdout.puts ( ((string)buf).substring(0,index) );
	}
	
	static void MakeRepeatFasta (string id, string desc, char[] alu, int n) {
		index = 0;
		int m = 0;
		int k = 0;
	 	int kn = alu.length;

		string descStr = ">" + id + " " + desc + "\n";
		stdout.puts (descStr);

		while (n > 0) {
			m = n < LineLength ? n : LineLength;

			if (buf.length - index < m) {
				// FIXME : Change the index to index +1 or index -1
				stdout.puts (((string)buf).substring(0,index));
				index = 0;
			}

			for (int i = 0; i < m ; i++) {
				if (k == kn)
					k = 0;

				buf[index++] = alu[k];
				k++;
			}

			buf[index++] = (char)'\n';
			n -= LineLength;
		}

		if (index != 0)
			stdout.puts (((string)buf).substring(0,index));
	}
}
