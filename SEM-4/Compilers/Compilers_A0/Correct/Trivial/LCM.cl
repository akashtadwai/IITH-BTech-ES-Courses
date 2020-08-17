   class Main inherits IO {
	a: INT <- 0;
	res:Int <- 0;
	b: Int <- 0;
     gcd(a: Int, b: Int) : Int {
		if a=0 then 0
        else
        {
        while(not(a=b)) loop 
        {
			if(b<a)	then a <-(a-b) 
            else
			b <- b-a
			fi;
		}
        pool;
		res <- a;
        res;
        }
        fi
	
};

    main() : Object {
	{
	    out_string("******* LCM of two numbers ******* \n");
	    out_string("Enter two non-zero positive numbers \n");
	    a <- in_int();
		b <- in_int();
	    out_string("LCM of ").out_int(a).out_string(" and ").out_int(b).out_string(" is equal to : ");
		out_int((a*b)/gcd(a,b)); -- lcm*gcd = product
	    out_string("\n");
	}
    };
};