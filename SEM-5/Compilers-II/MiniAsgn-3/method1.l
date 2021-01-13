%{
#include <stdlib.h>
#include "y.tab.h"
%}

%%
[0] {return ZERO;}
[1] {return ONE;}
[.] {return DOT;}
\n {return END;}
. {return ERROR;}
%%
int yywrap(void) {
 return 1;
} 