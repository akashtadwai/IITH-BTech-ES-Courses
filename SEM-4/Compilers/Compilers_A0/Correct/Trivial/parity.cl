class Main inherits IO {
 is_even(x : Int) : Bool {
    if x < 0 then is_even(~x) else
        if 0 = x then true else
	        if 1 = x then false else
	          is_even(x - 2)
	fi fi fi
   };
       main() : Object {
	{
	    out_string("*******Parity Checking of a number*******\n");
	    out_string("Enter a number to check even/odd\n");
	  	 if is_even(in_int())
	    	then out_string("It is an even number\n")
	    else out_string("It is an odd number\n")
	    fi;
    }};
};