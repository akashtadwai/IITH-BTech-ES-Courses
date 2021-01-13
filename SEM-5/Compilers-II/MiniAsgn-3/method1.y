%{
 #include <stdio.h>
 int yylex();
 int yyerror(char *);
%}

%union{
int ival;
double dval;
};


%start S 

%token ZERO ONE DOT ERROR END 

%type<ival>L B
%type<dval>N R S 

%%
S : N END  {$$ = $1;
            printf("%lf\n", $$);
            return 0;   // EOF
           }
N :   L DOT R {$$=$1+$3;}
    | L { $$ = $1;} // Just an integer

L :   L B {$$=$1*2+$2;}
    | B {$$=$1;}

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