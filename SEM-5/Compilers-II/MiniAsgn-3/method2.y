%{
 #include <stdio.h>
 int yylex();
 int yyerror(char *);
%}

%union{
double dval;
int ival;
struct bit {
    int len;
    int ival;
} bitstr;

};



%start S 
%token ZERO ONE DOT ERROR END

%type<dval>N R S
%type<bitstr>L 
%type<ival>B

%%
S : N END  {$$ = $1;
            printf("%lf\n", $$);
            return 0;   // EOF
           }

N :   L DOT R {$$=$1.ival+$3;}
    | L { $$ = $1.ival;}

L :   B L {$$.len = $2.len +1;
           $$.ival = $1 * (1<<$2.len )+ $2.ival ;
          }
    | B {$$.ival =$1;
         $$.len = 1; 
        }

R :   B R {$$ = ($1+$2)/(2.0);}
    | B {$$=$1/(2.0);}

B :   ZERO {$$=0;}
    | ONE  {$$=1;}

%%
int yyerror(char *s ) {
 fprintf(stdout, "Invalid String!");
 return 0;
} 
int main(void) {
 yyparse();
 return 0;
} 