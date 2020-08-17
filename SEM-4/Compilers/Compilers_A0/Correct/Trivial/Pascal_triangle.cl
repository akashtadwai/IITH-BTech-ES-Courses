class Main inherits IO {
	k: Int<-1;
    n: Int <- 1;
	i: Int <- 0;
       main() : Object {
	{
	    out_string("*****Nth row of Pascal Traingle (0-indexed) *****\n");
	    out_string("Enter a n to print nth row of pascal triangle\n");
		n <- in_int();
		out_int(n).out_string("th row of pascal triangle is : \n");
		while(i<=n)loop{
			out_int(k);
			out_string(" ");
			k<-k*(n-i)/(i+1); --Formula to calculate nth row of pascal triangle
			i<-i+1;
		}pool;
    }};
};