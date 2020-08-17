(* Program experimenting inheritance
*  by using complex numbers, it finds
*  Image of complex number wrt to x,y and y=x 
*  It also tells that if coordinates are equal
*)



class Complex inherits IO {
    x : Int<-0;
    y : Int<-0;

    init(a : Int, b : Int) : Complex { --Initialising values
	{
	    x <- a;
	    y <- b;
	    self;
	}
    };

    print() : Object { -- printing complex number
	if y = 0
	then out_int(x)
	else 
		out_int(x).out_string(" + ").out_string("i ").out_int(y)
	fi
    };

    image_xy() : Complex { --Image of point wrt y=x line
	{
	    x <- ~x;
	    y <- ~y;
		out_string("Image of complex number wrt y=x  is: ");
		print();
		out_string("\n");
	    self;
	}
    };

   image_X() : Complex { --image of point wrt X-axis
	{
	    y <- ~y;
		out_string("Image of complex number wrt X-axis  is: ");
		print();
		out_string("\n");
	    self;
	}
    };

    image_Y() : Complex { -- image of point wrt Y-axis
	{
	    x <- ~x;
		out_string("Image of complex number wrt y-axis  is: ");
		print();
		out_string("\n");
	    self;
	}
    };

    equal(d : Complex) : Bool {  -- To check if both coordinates of complex numbers are same
	if x = d.x_val()
	then
	    if y = d.x_val()
	    then true
	    else false
	    fi
	else false
	fi
    };

    x_val() : Int { --x coordinate of complex number
	x
    };

    y_val() : Int { --y coordinate of complex number
	y
    };
};



class Main inherits IO {
    x:Int <-0;
    y:Int <-0;
    c:Complex;
	main() : Object { 
        {
            out_string("Enter the real part of complex number \n");
            x<-in_int();
            out_string("Enter the imaginary part of complex number \n");
            y<-in_int();
            c<- (new Complex).init(x,y);
            c.image_X();
            c.image_Y();
	        if (c.equal(c))
	        then out_string(":) Real and Imaginary parts are equal\n")
	        else out_string(":( Real and imaginary parts are not equal) \n")
	        fi;
	        
        }
    };
};