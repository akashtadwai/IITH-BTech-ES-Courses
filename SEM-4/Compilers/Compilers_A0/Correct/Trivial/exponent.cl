class Main inherits IO {
a:Int <- 0;
b:Int <-0;
i:Int <-0;
s: String <- " \" This is Good \" ";
res:Int<-1;
 pow(a:Int, b: Int) : Int {
    if(a=0)  then  0
    else {
        i<-1;
        while(i<=b) loop{
            res <- res*a;
            i <- i+1;
        }pool;
        res;
    }
    fi
   };
       main() : Object {        
	{
        out_string(s).out_string("\n");
	    out_string("*******  Program to compute a power b  *******\n");
	    out_string("Enter the first number\n");
        a <-in_int();
        out_string("Enter the second number\n");
        b <- in_int();
        out_int(a).out_string(" power ").out_int(b).out_string(" is :");
	  	out_int(pow(a,b));
        out_string("\n");
    }};
};