(* x ^n is:
 *           x*{(x^2)^(n-1)/2}   if n is odd
 *          {x^2}^(n/2)         if n is even
 *)
 
class Main inherits IO {
res: Int <- 1;
x:Int <-0;
y:Int<-0;
is_even(x : Int) : Bool {
    if x < 0 then is_even(~x) else
        if 0 = x then true else
	        if 1 = x then false else
	          is_even(x - 2)
	fi fi fi
   };

fast_expon(x:Int, y: Int) : Int {
    if(x=0) then 0 else{
        while(0<y) loop{
        if(is_even(y)=false)  then res<- res * x else 0 fi;
        y <- y/2;
        x <- x*x;
    } pool;
    res <- res;
} fi   
   };
       main() : Object {
	{
	    out_string("*******Fast Modular Exponentiation*******\n");
	    out_string("Enter the base \n");
        x <- in_int();
        out_string("Enter the exponent \n");
        y <- in_int();
        out_int(x).out_string(" power ").out_int(y).out_string(" is : ");
        out_int(fast_expon(x,y));
        out_string("\n");
    }};
};