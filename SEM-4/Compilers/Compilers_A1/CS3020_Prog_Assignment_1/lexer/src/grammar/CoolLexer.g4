lexer grammar CoolLexer;

tokens {
	ERROR,
	TYPEID,
	OBJECTID,
	BOOL_CONST,
	INT_CONST,
	STR_CONST,
	LPAREN,
	RPAREN,
	COLON,
	ATSYM,
	SEMICOLON,
	COMMA,
	PLUS,
	MINUS,
	STAR,
	SLASH,
	TILDE,
	LT,
	EQUALS,
	LBRACE,
	RBRACE,
	DOT,
	DARROW,
	LE,
	ASSIGN,
	CLASS,
	ELSE,
	FI,
	IF,
	IN,
	INHERITS,
	LET,
	LOOP,
	POOL,
	THEN,
	WHILE,
	CASE,
	ESAC,
	OF,
	NEW,
	ISVOID,
	NOT
}

/*
 DO NOT EDIT CODE ABOVE THIS LINE
 */

@members {

	/*
		YOU CAN ADD YOUR MEMBER VARIABLES AND METHODS HERE
	*/

	/**
	* Function to report errors.
	* Use this function whenever your lexer encounters any erroneous input
	* DO NOT EDIT THIS FUNCTION	
	*/
	public void reportError(String errorString){
		setText(errorString);
		setType(ERROR);
	}	

	// UknownToken() reports an error if an unknown token is found
	public void UknownToken(){
		Token t = _factory.create(_tokenFactorySourcePair, _type, _text, _channel, _tokenStartCharIndex, getCharIndex()-1, _tokenStartLine, _tokenStartCharPositionInLine);
		String text = t.getText();
		reportError(text);
	}

	// processString() processes a string for escaped characters
	public void processString() {
		Token t = _factory.create(_tokenFactorySourcePair, _type, _text, _channel, _tokenStartCharIndex, getCharIndex()-1, _tokenStartLine, _tokenStartCharPositionInLine);
		String text = t.getText();

		//write your code to test strings here
		boolean llong=false,null_char=false,unesc=false,eof=false,esc_null_char=false,beof=false; // when beof is true last backslash is escaped
		int len = text.length(),cnt=0;

		if(text.charAt(len-1)=='\n')	unesc=true;

		if(text.charAt(len-1)!='"' && text.charAt(len-1)!='\n') eof=true;

		String temp = "";
		for(int i=1;i<text.length()-1;i++) {
			if(text.charAt(i) == '\u0000'){
				null_char=true;
				break;
			}
			else if(text.charAt(i)=='\\') {
				char next = text.charAt(i+1);
				switch(next){
					case '\u0000':
						esc_null_char=true;
						break;
					case 't':
						temp = temp.concat("\t");
						break;
					case 'n':
						temp+='\n';
						break; 
					case 'b':
						temp = temp.concat("\b");
						break;
					case 'f':
						temp = temp.concat("\f");
						break;
					case '\n':
						if(i+1==text.length()-1) eof=true;
						temp+='\n';
						break;    
					case '\\':
						if(i+1==text.length()-1) beof=true;
						temp+='\\';
						break;
					case '\"':
						if(i+1==text.length()-1) eof=true;
						temp+='\"';
						break;
					default : 
						temp+= String.valueOf(text.charAt(i+1));
				}
				i++;
			}
			else temp = temp.concat(String.valueOf(text.charAt(i)));
			cnt+=1;
			if(cnt>1024)	llong=true;
			if(cnt>1025) {llong=true;break; }
		}
		if(null_char){
			reportError("String contains null character.");
			return;
		 }
		if(esc_null_char){
			reportError("String contains escaped null character.");
			return;
		 }
		if(llong){ 
			reportError("String constant too long");
			return;	
		}
		if(eof && text.charAt(len-1) == '\\' && !beof){ 
				reportError("backslash at end of file");
				return;
		}
		if(eof || beof){ 
			reportError("EOF in string constant");
			return;	
		}
		if(unesc && cnt<1026){  
			reportError("Unterminated string constant");
			return;
		}
		setText(temp);
	}

}

/*
 WRITE ALL LEXER RULES BELOW
 */

/* Operators */
SEMICOLON	: ';';
DARROW		: '=>';
LPAREN		: '(';
RPAREN		: ')';
DOT			: '.';
ATSYM		: '@';
TILDE		: '~';
PLUS		: '+';
MINUS		: '-';
STAR		: '*';
SLASH		: '/';
COMMA		: ',';
EQUALS		: '=';
LT			: '<';
LE			: '<=';
LBRACE		: '{';
RBRACE		: '}';
ASSIGN		: '<-';
COLON		: ':';

/* KeyWords are case insensitive */ 

NEW						: ('n' | 'N') ('e' | 'E') ('w' | 'W');
CLASS					: ('c'|'C')('l'|'L')('a'|'A')('s'|'S')('s'|'S');
INHERITS				: ('i'|'I')('n'|'N')('h'|'H')('e'|'E')('r'|'R')('i'|'I')('t'|'T')('s'|'S');
ISVOID					: ('i'|'I')('s'|'S')('v'|'V')('o'|'O')('i'|'I')('d'|'D');
LET						: ('l'|'L')('e'|'E')('t'|'T');
IN						: ('i'|'I')('n'|'N');
IF						: ('i'|'I')('f'|'F');
THEN					: ('t'|'T')('h'|'H')('e'|'E')('n'|'N');
ELSE					: ('e'|'E')('l'|'L')('s'|'S')('e'|'E');
FI						: ('f'|'F')('i'|'I');
WHILE					: ('w'|'W')('h'|'H')('i'|'I')('l'|'L')('e'|'E');
LOOP					: ('l'|'L')('o'|'O')('o'|'O')('p'|'P');
POOL					: ('p'|'P')('o'|'O')('o'|'O')('l'|'L');
CASE					: ('c'|'C')('a'|'A')('s'|'S')('e'|'E');
ESAC					: ('e'|'E')('s'|'S')('a'|'A')('c'|'C');
OF						: ('o'|'O')('f'|'F');
NOT						: ('n'|'N')('o'|'O')('t'|'T');

/*Identifiers */

fragment DIGIT		: [0-9];
fragment LLETTER	: [a-z];
fragment ULETTER	: [A-Z];
fragment LETTER		: (LLETTER|ULETTER);
fragment TRUE		: 't'('r'|'R')('u'|'U')('e'|'E'); // First letter must be lowercase
fragment FALSE		: 'f'('a'|'A')('l'|'L')('s'|'S')('e'|'E');
BOOL_CONST			: (TRUE|FALSE);
INT_CONST			: DIGIT+;
TYPEID				: ULETTER('_'|LETTER|DIGIT)*|SELF_TYPE;
OBJECTID			: LLETTER('_'|LETTER|DIGIT)*|SELF;
SELF				: 'self' ;
SELF_TYPE			: 'SELF_TYPE' ;

/*Processing strings and White Spaces */

WHITESPACE: ([ \r\t\n\f]| ('\u000b'))+  -> skip;
STR_CONST:
	(TERMINATED|UN_TERMINATED|EOF_STRING)	 {processString ();};
TERMINATED: '"' ('\\' (.) | ~('\n' | '\\' | '"'))*? '"';
UN_TERMINATED: '"' ('\\' (.) | ~('\n' | '\\' | '"'))*? '\n';
EOF_STRING: '"' ('\\' (.) | ~('\n' | '\\' | '"'))*? ('\\')? (EOF);

OTHER: . {UknownToken();};


// Comment Lexer Rules

SINGLE_LINE_COMMENT: '--' .*? ('\n'|(EOF)) -> skip;
END_MULTI_COMMENT: '*)' EOF? { reportError("Unmatched *)"); };
EOF_NESTED_START : '(*'(EOF) {reportError("EOF in comment"); };
BEGIN_NESTED_COMMENT1:
	'(*' -> pushMode(IN_MULTI_COMMENT), skip;

mode IN_MULTI_COMMENT;
ERR: .(EOF) { reportError("EOF in comment"); };
BEGIN_NESTED_COMMENT2:
	'(*' -> pushMode(IN_IN_MULTI_COM), skip;
END_NESTED_COMMENT1: '*)' -> popMode, skip;
IM_MULTI_COMMENT_T: . -> skip;

mode IN_IN_MULTI_COM;

EOF_NESTED_MODE : '(*'(EOF) {reportError("EOF in comment"); };
ERR2: .(EOF) { reportError("EOF in comment"); };
BEGIN_NESTED_COMMENT3:
	'(*' -> pushMode(IN_IN_MULTI_COM), skip;
ERR3: '*)' EOF { reportError("EOF in comment"); };
END_NESTED_COMMENT2: '*)' -> popMode, skip;
IM_NESTED_COMMENT_T: . -> skip;