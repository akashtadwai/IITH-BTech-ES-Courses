class Main {
	a : Int; -- some declarations
	c : bool;
	main():IO {
		{
		--(*(*This won't be displayed as this is a comment *))
		a <- 3 ;
		s: String <- "This assignment is about Cool\'s lexical specifications" ; -- Single quote will be escaped
		s : String <- "This is \	normal string ";
		t : String <- "\\n\\t\\a\\\f \         This is some text to print";
		s : String <-"This string contains NULL character  ";
		q : String <- "adfsdf\
Newline is escaped here";
		r: String <- "\" This is Cool language \" ";
		out_string(s);
		$ This is UnknownToken;
		*)
		}
	};
};
(*					(*/*case '\"':
						temp+='\"';
						break;
					case '\'':
						temp+='\'';
						break;
					case '\\':
					    char ch = '\\';
						temp += ch;
						break;*/*) --This is a nested comment in cool
*)