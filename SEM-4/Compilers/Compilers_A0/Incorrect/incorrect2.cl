 
class Main inherits IO {
	s: string <- "Hey! I'm Akash \0 \n"; -- Non-escaped characters should not be present
   main(): SELF_TYPE {
		out_string(s)
   };
};