{
    open Printf
    open Parser
}

let character = ['A'-'Z' 'a'-'z']   
let element = ['A'-'Z']['a'-'z']?
let digit  = ['0'-'9']

(* tokenising symbols,operators,keywords,numbers,strings  *)
rule tokens = parse
    [' ' '\t' '\r' '\n']	{ tokens lexbuf }
    |';'                    {SEMICOLON }
    |':'                    {COLON} 
    |'"'                    {APOS}   
    |'('                    {LPAREN}
    |')'                    {RPAREN}
    |'{'                    {LBRACE}
    |'}'                    {RBRACE}
    |'['                    {LBRACKET}
    |']'                    {RBRACKET}
    |','                    {COMMA}
    |'+'                    {PLUS}
    |'-'                    {MINUS}
    |'*'                    {MUL}
    |'/'                    {DIV}
    |'%'                    {MOD} 
    |'.'                    {ACCESS}
    |'^'                    {CONCATENATE}
    |'='                    {ASSIGN}
    |"=="                   {EQ}
    |"!="                   {NEQ}
    |'<'                    {LT}
    |"<="                   {LTQ}
    |'>'                    {GT}
    |">="                   {GTQ}
    | '&'                   {BITAND}
    | '|'                   {BITOR}
    |"&&"                   {AND}
    |"||"                   {OR}
    |'!'                    {NOT}
    | "-->"                 {ARROW} (*Remove later if not required*)
    |"if"                   {IF}
    |"else"                 {ELSE}
    |"while"                {WHILE}
    |"for"                  {FOR}
    |"int"                  {INT}
    |"double"               {DOUBLE}
    |"string"               {STRING}
    |"boolean"              {BOOLEAN}
    |"element"              {ELEMENT }      
    |"molecule"             {MOLECULE}
    |"equation"             {EQUATION}
    |"balance"              {BALANCE}
    |"mol_mass"             {MOLAR_MASS}
    |"mol_charge"           {MOL_CHARGE}
    |"mol_electrons"        {MOL_ELECTRON}
    |"mass"  as attr        {ATTRIBUTE(attr)}
    |"charge" as attr       {ATTRIBUTE(attr)}
    |"electrons" as attr    {ATTRIBUTE(attr)}
    |"def"                  {FUNCTION} (* diff *)
    |"object"               {OBJECT}
    |"return"               {RETURN}
    |"print"                {PRINT}   
    |"call"                 {CALL}
	|"true" as lexemme		{BOOLEAN_LITERAL(bool_of_string lexemme)}
    |"false" as lexemme	    {BOOLEAN_LITERAL(bool_of_string lexemme)}
    | "-"?(digit)+ '.'(digit)+ as lexemme  {DOUBLE_LITERAL(float_of_string lexemme)}
    |  "-"?digit+ as lexemme         {INTEGER_LITERAL(int_of_string lexemme)}
    |  element as lexemme       {ELEMENT_LITERAL(lexemme)}
    | (element digit*)+ as lexemme         {MOLECULE_LITERAL(lexemme)}
    | '"' [^'"' '\n']                   {printf "Unterminated string constant \n";exit(1)}
    | '"' [^'"' '\n']*'"' as lexemme           {STRING_LITERAL(lexemme)}
    |['a' - 'z'](character|digit)* as lexemme { ID(lexemme)}
    | eof                       {EOF} 
    | _ {printf "Invalid token \n ";exit(1)}

    | "/*"		{multiline_comment_mode lexbuf }
    | "//"	{singleline_comment_mode lexbuf }



    (* Single line comments *)
and singleline_comment_mode = parse
    '\n'	{tokens lexbuf}
    | eof   {EOF}
    | _ {singleline_comment_mode lexbuf } 


        (* Multi line comments *)
and multiline_comment_mode = parse
    "*/"  {tokens lexbuf}
  | eof   {printf "Unterminated multi-line comment \n";exit(1)}
  | _ {multiline_comment_mode lexbuf}