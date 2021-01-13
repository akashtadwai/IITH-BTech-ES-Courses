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

%type<dval>N S 
%type<bitstr>X
%type<ival>B

%%
S : N END  {$$ = $1;
            printf("%lf\n", $$);
            return 0;   // EOF
           }

N :   X DOT X {$$= $1.ival + $3.ival*1.0 /(1<<$3.len) ; }
    | X { $$ = $1.ival;}

X :   B X {$$.len = $2.len + 1; 
           $$.ival = $1*(1<<($2.len)) + $2.ival; }
    | B {$$.len=1; $$.ival = $1;}

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