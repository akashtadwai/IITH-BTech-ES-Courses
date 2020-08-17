 
class Main inherits IO {
	s: string <- "Lets be Cool! \n"; -- Type Identifier should begin with capital letter
   main(): SELF_TYPE {
		out_string(s)
   };
};