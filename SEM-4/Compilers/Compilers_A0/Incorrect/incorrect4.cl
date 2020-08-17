class Main inherits IO {
	x : Bool <- False;	--case sensitive keyword
   main(): SELF_TYPE {
   		if x then out_string("False\n")
   		else out_string("True\n")
   		fi
   };
};