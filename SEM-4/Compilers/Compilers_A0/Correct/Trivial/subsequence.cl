class Main inherits IO {
a:String; 
b:String;
 is_subsequence(a:String, b:String, i:Int, j:Int) : Bool {
    if(i=0)  then  true
    else if(j=0)   then false
    else if(a.substr(i -1, 1)=b.substr(j - 1, 1))  then is_subsequence(a,b,i-1,j-1)
    else is_subsequence(a,b,i,j-1)
    fi fi fi
   };
       main() : Object {
	{
	    out_string("*******Checking if first string is a subsequence of second string *******\n");
	    out_string("Enter the first string\n");
        a <-in_string();
        b <- in_string();
        out_string("Enter the second string\n");
	  	 if (is_subsequence(a,b,a.length(),b.length()))
	    	then out_string("First is subsequence of Second\n")
	    else out_string("First is not subsequence of second\n")
	    fi;
    }};
};