// Generated from /home/akash/Desktop/Compilers/Compilers_A1/CS3020_Prog_Assignment_1/lexer/src/grammar/CoolLexer.g4 by ANTLR 4.7.1
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.misc.*;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class CoolLexer extends Lexer {
	static { RuntimeMetaData.checkVersion("4.7.1", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		ERROR=1, TYPEID=2, OBJECTID=3, BOOL_CONST=4, INT_CONST=5, STR_CONST=6, 
		LPAREN=7, RPAREN=8, COLON=9, ATSYM=10, SEMICOLON=11, COMMA=12, PLUS=13, 
		MINUS=14, STAR=15, SLASH=16, TILDE=17, LT=18, EQUALS=19, LBRACE=20, RBRACE=21, 
		DOT=22, DARROW=23, LE=24, ASSIGN=25, CLASS=26, ELSE=27, FI=28, IF=29, 
		IN=30, INHERITS=31, LET=32, LOOP=33, POOL=34, THEN=35, WHILE=36, CASE=37, 
		ESAC=38, OF=39, NEW=40, ISVOID=41, NOT=42, SELF=43, SELF_TYPE=44, WHITESPACE=45, 
		TERMINATED=46, UN_TERMINATED=47, EOF_STRING=48, OTHER=49, SINGLE_LINE_COMMENT=50, 
		END_MULTI_COMMENT=51, EOF_NESTED_START=52, BEGIN_NESTED_COMMENT1=53, ERR=54, 
		BEGIN_NESTED_COMMENT2=55, END_NESTED_COMMENT1=56, IM_MULTI_COMMENT_T=57, 
		EOF_NESTED_MODE=58, ERR2=59, BEGIN_NESTED_COMMENT3=60, ERR3=61, END_NESTED_COMMENT2=62, 
		IM_NESTED_COMMENT_T=63;
	public static final int
		IN_MULTI_COMMENT=1, IN_IN_MULTI_COM=2;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE", "IN_MULTI_COMMENT", "IN_IN_MULTI_COM"
	};

	public static final String[] ruleNames = {
		"SEMICOLON", "DARROW", "LPAREN", "RPAREN", "DOT", "ATSYM", "TILDE", "PLUS", 
		"MINUS", "STAR", "SLASH", "COMMA", "EQUALS", "LT", "LE", "LBRACE", "RBRACE", 
		"ASSIGN", "COLON", "NEW", "CLASS", "INHERITS", "ISVOID", "LET", "IN", 
		"IF", "THEN", "ELSE", "FI", "WHILE", "LOOP", "POOL", "CASE", "ESAC", "OF", 
		"NOT", "DIGIT", "LLETTER", "ULETTER", "LETTER", "TRUE", "FALSE", "BOOL_CONST", 
		"INT_CONST", "TYPEID", "OBJECTID", "SELF", "SELF_TYPE", "WHITESPACE", 
		"STR_CONST", "TERMINATED", "UN_TERMINATED", "EOF_STRING", "OTHER", "SINGLE_LINE_COMMENT", 
		"END_MULTI_COMMENT", "EOF_NESTED_START", "BEGIN_NESTED_COMMENT1", "ERR", 
		"BEGIN_NESTED_COMMENT2", "END_NESTED_COMMENT1", "IM_MULTI_COMMENT_T", 
		"EOF_NESTED_MODE", "ERR2", "BEGIN_NESTED_COMMENT3", "ERR3", "END_NESTED_COMMENT2", 
		"IM_NESTED_COMMENT_T"
	};

	private static final String[] _LITERAL_NAMES = {
		null, null, null, null, null, null, null, "'('", "')'", "':'", "'@'", 
		"';'", "','", "'+'", "'-'", "'*'", "'/'", "'~'", "'<'", "'='", "'{'", 
		"'}'", "'.'", "'=>'", "'<='", "'<-'", null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, "'self'", 
		"'SELF_TYPE'"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, "ERROR", "TYPEID", "OBJECTID", "BOOL_CONST", "INT_CONST", "STR_CONST", 
		"LPAREN", "RPAREN", "COLON", "ATSYM", "SEMICOLON", "COMMA", "PLUS", "MINUS", 
		"STAR", "SLASH", "TILDE", "LT", "EQUALS", "LBRACE", "RBRACE", "DOT", "DARROW", 
		"LE", "ASSIGN", "CLASS", "ELSE", "FI", "IF", "IN", "INHERITS", "LET", 
		"LOOP", "POOL", "THEN", "WHILE", "CASE", "ESAC", "OF", "NEW", "ISVOID", 
		"NOT", "SELF", "SELF_TYPE", "WHITESPACE", "TERMINATED", "UN_TERMINATED", 
		"EOF_STRING", "OTHER", "SINGLE_LINE_COMMENT", "END_MULTI_COMMENT", "EOF_NESTED_START", 
		"BEGIN_NESTED_COMMENT1", "ERR", "BEGIN_NESTED_COMMENT2", "END_NESTED_COMMENT1", 
		"IM_MULTI_COMMENT_T", "EOF_NESTED_MODE", "ERR2", "BEGIN_NESTED_COMMENT3", 
		"ERR3", "END_NESTED_COMMENT2", "IM_NESTED_COMMENT_T"
	};
	public static final Vocabulary VOCABULARY = new VocabularyImpl(_LITERAL_NAMES, _SYMBOLIC_NAMES);

	/**
	 * @deprecated Use {@link #VOCABULARY} instead.
	 */
	@Deprecated
	public static final String[] tokenNames;
	static {
		tokenNames = new String[_SYMBOLIC_NAMES.length];
		for (int i = 0; i < tokenNames.length; i++) {
			tokenNames[i] = VOCABULARY.getLiteralName(i);
			if (tokenNames[i] == null) {
				tokenNames[i] = VOCABULARY.getSymbolicName(i);
			}

			if (tokenNames[i] == null) {
				tokenNames[i] = "<INVALID>";
			}
		}
	}

	@Override
	@Deprecated
	public String[] getTokenNames() {
		return tokenNames;
	}

	@Override

	public Vocabulary getVocabulary() {
		return VOCABULARY;
	}



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



	public CoolLexer(CharStream input) {
		super(input);
		_interp = new LexerATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@Override
	public String getGrammarFileName() { return "CoolLexer.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public String[] getChannelNames() { return channelNames; }

	@Override
	public String[] getModeNames() { return modeNames; }

	@Override
	public ATN getATN() { return _ATN; }

	@Override
	public void action(RuleContext _localctx, int ruleIndex, int actionIndex) {
		switch (ruleIndex) {
		case 49:
			STR_CONST_action((RuleContext)_localctx, actionIndex);
			break;
		case 53:
			OTHER_action((RuleContext)_localctx, actionIndex);
			break;
		case 55:
			END_MULTI_COMMENT_action((RuleContext)_localctx, actionIndex);
			break;
		case 56:
			EOF_NESTED_START_action((RuleContext)_localctx, actionIndex);
			break;
		case 58:
			ERR_action((RuleContext)_localctx, actionIndex);
			break;
		case 62:
			EOF_NESTED_MODE_action((RuleContext)_localctx, actionIndex);
			break;
		case 63:
			ERR2_action((RuleContext)_localctx, actionIndex);
			break;
		case 65:
			ERR3_action((RuleContext)_localctx, actionIndex);
			break;
		}
	}
	private void STR_CONST_action(RuleContext _localctx, int actionIndex) {
		switch (actionIndex) {
		case 0:
			processString ();
			break;
		}
	}
	private void OTHER_action(RuleContext _localctx, int actionIndex) {
		switch (actionIndex) {
		case 1:
			UknownToken();
			break;
		}
	}
	private void END_MULTI_COMMENT_action(RuleContext _localctx, int actionIndex) {
		switch (actionIndex) {
		case 2:
			 reportError("Unmatched *)"); 
			break;
		}
	}
	private void EOF_NESTED_START_action(RuleContext _localctx, int actionIndex) {
		switch (actionIndex) {
		case 3:
			reportError("EOF in comment"); 
			break;
		}
	}
	private void ERR_action(RuleContext _localctx, int actionIndex) {
		switch (actionIndex) {
		case 4:
			 reportError("EOF in comment"); 
			break;
		}
	}
	private void EOF_NESTED_MODE_action(RuleContext _localctx, int actionIndex) {
		switch (actionIndex) {
		case 5:
			reportError("EOF in comment"); 
			break;
		}
	}
	private void ERR2_action(RuleContext _localctx, int actionIndex) {
		switch (actionIndex) {
		case 6:
			 reportError("EOF in comment"); 
			break;
		}
	}
	private void ERR3_action(RuleContext _localctx, int actionIndex) {
		switch (actionIndex) {
		case 7:
			 reportError("EOF in comment"); 
			break;
		}
	}

	public static final String _serializedATN =
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2A\u01d8\b\1\b\1\b"+
		"\1\4\2\t\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n"+
		"\t\n\4\13\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21"+
		"\4\22\t\22\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30"+
		"\4\31\t\31\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4\36\t\36\4\37\t\37"+
		"\4 \t \4!\t!\4\"\t\"\4#\t#\4$\t$\4%\t%\4&\t&\4\'\t\'\4(\t(\4)\t)\4*\t"+
		"*\4+\t+\4,\t,\4-\t-\4.\t.\4/\t/\4\60\t\60\4\61\t\61\4\62\t\62\4\63\t\63"+
		"\4\64\t\64\4\65\t\65\4\66\t\66\4\67\t\67\48\t8\49\t9\4:\t:\4;\t;\4<\t"+
		"<\4=\t=\4>\t>\4?\t?\4@\t@\4A\tA\4B\tB\4C\tC\4D\tD\4E\tE\3\2\3\2\3\3\3"+
		"\3\3\3\3\4\3\4\3\5\3\5\3\6\3\6\3\7\3\7\3\b\3\b\3\t\3\t\3\n\3\n\3\13\3"+
		"\13\3\f\3\f\3\r\3\r\3\16\3\16\3\17\3\17\3\20\3\20\3\20\3\21\3\21\3\22"+
		"\3\22\3\23\3\23\3\23\3\24\3\24\3\25\3\25\3\25\3\25\3\26\3\26\3\26\3\26"+
		"\3\26\3\26\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\30\3\30\3\30"+
		"\3\30\3\30\3\30\3\30\3\31\3\31\3\31\3\31\3\32\3\32\3\32\3\33\3\33\3\33"+
		"\3\34\3\34\3\34\3\34\3\34\3\35\3\35\3\35\3\35\3\35\3\36\3\36\3\36\3\37"+
		"\3\37\3\37\3\37\3\37\3\37\3 \3 \3 \3 \3 \3!\3!\3!\3!\3!\3\"\3\"\3\"\3"+
		"\"\3\"\3#\3#\3#\3#\3#\3$\3$\3$\3%\3%\3%\3%\3&\3&\3\'\3\'\3(\3(\3)\3)\5"+
		")\u0111\n)\3*\3*\3*\3*\3*\3+\3+\3+\3+\3+\3+\3,\3,\5,\u0120\n,\3-\6-\u0123"+
		"\n-\r-\16-\u0124\3.\3.\3.\3.\7.\u012b\n.\f.\16.\u012e\13.\3.\5.\u0131"+
		"\n.\3/\3/\3/\3/\7/\u0137\n/\f/\16/\u013a\13/\3/\5/\u013d\n/\3\60\3\60"+
		"\3\60\3\60\3\60\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\62"+
		"\6\62\u014f\n\62\r\62\16\62\u0150\3\62\3\62\3\63\3\63\3\63\5\63\u0158"+
		"\n\63\3\63\3\63\3\64\3\64\3\64\3\64\7\64\u0160\n\64\f\64\16\64\u0163\13"+
		"\64\3\64\3\64\3\65\3\65\3\65\3\65\7\65\u016b\n\65\f\65\16\65\u016e\13"+
		"\65\3\65\3\65\3\66\3\66\3\66\3\66\7\66\u0176\n\66\f\66\16\66\u0179\13"+
		"\66\3\66\5\66\u017c\n\66\3\66\3\66\3\67\3\67\3\67\38\38\38\38\78\u0187"+
		"\n8\f8\168\u018a\138\38\58\u018d\n8\38\38\39\39\39\39\59\u0195\n9\39\3"+
		"9\3:\3:\3:\3:\3:\3:\3;\3;\3;\3;\3;\3;\3<\3<\3<\3<\3=\3=\3=\3=\3=\3=\3"+
		">\3>\3>\3>\3>\3>\3?\3?\3?\3?\3@\3@\3@\3@\3@\3@\3A\3A\3A\3A\3B\3B\3B\3"+
		"B\3B\3B\3C\3C\3C\3C\3C\3C\3D\3D\3D\3D\3D\3D\3E\3E\3E\3E\6\u0161\u016c"+
		"\u0177\u0188\2F\5\r\7\31\t\t\13\n\r\30\17\f\21\23\23\17\25\20\27\21\31"+
		"\22\33\16\35\25\37\24!\32#\26%\27\'\33)\13+*-\34/!\61+\63\"\65 \67\37"+
		"9%;\35=\36?&A#C$E\'G(I)K,M\2O\2Q\2S\2U\2W\2Y\6[\7]\4_\5a-c.e/g\bi\60k"+
		"\61m\62o\63q\64s\65u\66w\67y8{9}:\177;\u0081<\u0083=\u0085>\u0087?\u0089"+
		"@\u008bA\5\2\3\4\31\4\2PPpp\4\2GGgg\4\2YYyy\4\2EEee\4\2NNnn\4\2CCcc\4"+
		"\2UUuu\4\2KKkk\4\2JJjj\4\2TTtt\4\2VVvv\4\2XXxx\4\2QQqq\4\2FFff\4\2HHh"+
		"h\4\2RRrr\3\2\62;\3\2c|\3\2C\\\4\2WWww\4\2\13\17\"\"\5\2\f\f$$^^\3\3\f"+
		"\f\2\u01e6\2\5\3\2\2\2\2\7\3\2\2\2\2\t\3\2\2\2\2\13\3\2\2\2\2\r\3\2\2"+
		"\2\2\17\3\2\2\2\2\21\3\2\2\2\2\23\3\2\2\2\2\25\3\2\2\2\2\27\3\2\2\2\2"+
		"\31\3\2\2\2\2\33\3\2\2\2\2\35\3\2\2\2\2\37\3\2\2\2\2!\3\2\2\2\2#\3\2\2"+
		"\2\2%\3\2\2\2\2\'\3\2\2\2\2)\3\2\2\2\2+\3\2\2\2\2-\3\2\2\2\2/\3\2\2\2"+
		"\2\61\3\2\2\2\2\63\3\2\2\2\2\65\3\2\2\2\2\67\3\2\2\2\29\3\2\2\2\2;\3\2"+
		"\2\2\2=\3\2\2\2\2?\3\2\2\2\2A\3\2\2\2\2C\3\2\2\2\2E\3\2\2\2\2G\3\2\2\2"+
		"\2I\3\2\2\2\2K\3\2\2\2\2Y\3\2\2\2\2[\3\2\2\2\2]\3\2\2\2\2_\3\2\2\2\2a"+
		"\3\2\2\2\2c\3\2\2\2\2e\3\2\2\2\2g\3\2\2\2\2i\3\2\2\2\2k\3\2\2\2\2m\3\2"+
		"\2\2\2o\3\2\2\2\2q\3\2\2\2\2s\3\2\2\2\2u\3\2\2\2\2w\3\2\2\2\3y\3\2\2\2"+
		"\3{\3\2\2\2\3}\3\2\2\2\3\177\3\2\2\2\4\u0081\3\2\2\2\4\u0083\3\2\2\2\4"+
		"\u0085\3\2\2\2\4\u0087\3\2\2\2\4\u0089\3\2\2\2\4\u008b\3\2\2\2\5\u008d"+
		"\3\2\2\2\7\u008f\3\2\2\2\t\u0092\3\2\2\2\13\u0094\3\2\2\2\r\u0096\3\2"+
		"\2\2\17\u0098\3\2\2\2\21\u009a\3\2\2\2\23\u009c\3\2\2\2\25\u009e\3\2\2"+
		"\2\27\u00a0\3\2\2\2\31\u00a2\3\2\2\2\33\u00a4\3\2\2\2\35\u00a6\3\2\2\2"+
		"\37\u00a8\3\2\2\2!\u00aa\3\2\2\2#\u00ad\3\2\2\2%\u00af\3\2\2\2\'\u00b1"+
		"\3\2\2\2)\u00b4\3\2\2\2+\u00b6\3\2\2\2-\u00ba\3\2\2\2/\u00c0\3\2\2\2\61"+
		"\u00c9\3\2\2\2\63\u00d0\3\2\2\2\65\u00d4\3\2\2\2\67\u00d7\3\2\2\29\u00da"+
		"\3\2\2\2;\u00df\3\2\2\2=\u00e4\3\2\2\2?\u00e7\3\2\2\2A\u00ed\3\2\2\2C"+
		"\u00f2\3\2\2\2E\u00f7\3\2\2\2G\u00fc\3\2\2\2I\u0101\3\2\2\2K\u0104\3\2"+
		"\2\2M\u0108\3\2\2\2O\u010a\3\2\2\2Q\u010c\3\2\2\2S\u0110\3\2\2\2U\u0112"+
		"\3\2\2\2W\u0117\3\2\2\2Y\u011f\3\2\2\2[\u0122\3\2\2\2]\u0130\3\2\2\2_"+
		"\u013c\3\2\2\2a\u013e\3\2\2\2c\u0143\3\2\2\2e\u014e\3\2\2\2g\u0157\3\2"+
		"\2\2i\u015b\3\2\2\2k\u0166\3\2\2\2m\u0171\3\2\2\2o\u017f\3\2\2\2q\u0182"+
		"\3\2\2\2s\u0190\3\2\2\2u\u0198\3\2\2\2w\u019e\3\2\2\2y\u01a4\3\2\2\2{"+
		"\u01a8\3\2\2\2}\u01ae\3\2\2\2\177\u01b4\3\2\2\2\u0081\u01b8\3\2\2\2\u0083"+
		"\u01be\3\2\2\2\u0085\u01c2\3\2\2\2\u0087\u01c8\3\2\2\2\u0089\u01ce\3\2"+
		"\2\2\u008b\u01d4\3\2\2\2\u008d\u008e\7=\2\2\u008e\6\3\2\2\2\u008f\u0090"+
		"\7?\2\2\u0090\u0091\7@\2\2\u0091\b\3\2\2\2\u0092\u0093\7*\2\2\u0093\n"+
		"\3\2\2\2\u0094\u0095\7+\2\2\u0095\f\3\2\2\2\u0096\u0097\7\60\2\2\u0097"+
		"\16\3\2\2\2\u0098\u0099\7B\2\2\u0099\20\3\2\2\2\u009a\u009b\7\u0080\2"+
		"\2\u009b\22\3\2\2\2\u009c\u009d\7-\2\2\u009d\24\3\2\2\2\u009e\u009f\7"+
		"/\2\2\u009f\26\3\2\2\2\u00a0\u00a1\7,\2\2\u00a1\30\3\2\2\2\u00a2\u00a3"+
		"\7\61\2\2\u00a3\32\3\2\2\2\u00a4\u00a5\7.\2\2\u00a5\34\3\2\2\2\u00a6\u00a7"+
		"\7?\2\2\u00a7\36\3\2\2\2\u00a8\u00a9\7>\2\2\u00a9 \3\2\2\2\u00aa\u00ab"+
		"\7>\2\2\u00ab\u00ac\7?\2\2\u00ac\"\3\2\2\2\u00ad\u00ae\7}\2\2\u00ae$\3"+
		"\2\2\2\u00af\u00b0\7\177\2\2\u00b0&\3\2\2\2\u00b1\u00b2\7>\2\2\u00b2\u00b3"+
		"\7/\2\2\u00b3(\3\2\2\2\u00b4\u00b5\7<\2\2\u00b5*\3\2\2\2\u00b6\u00b7\t"+
		"\2\2\2\u00b7\u00b8\t\3\2\2\u00b8\u00b9\t\4\2\2\u00b9,\3\2\2\2\u00ba\u00bb"+
		"\t\5\2\2\u00bb\u00bc\t\6\2\2\u00bc\u00bd\t\7\2\2\u00bd\u00be\t\b\2\2\u00be"+
		"\u00bf\t\b\2\2\u00bf.\3\2\2\2\u00c0\u00c1\t\t\2\2\u00c1\u00c2\t\2\2\2"+
		"\u00c2\u00c3\t\n\2\2\u00c3\u00c4\t\3\2\2\u00c4\u00c5\t\13\2\2\u00c5\u00c6"+
		"\t\t\2\2\u00c6\u00c7\t\f\2\2\u00c7\u00c8\t\b\2\2\u00c8\60\3\2\2\2\u00c9"+
		"\u00ca\t\t\2\2\u00ca\u00cb\t\b\2\2\u00cb\u00cc\t\r\2\2\u00cc\u00cd\t\16"+
		"\2\2\u00cd\u00ce\t\t\2\2\u00ce\u00cf\t\17\2\2\u00cf\62\3\2\2\2\u00d0\u00d1"+
		"\t\6\2\2\u00d1\u00d2\t\3\2\2\u00d2\u00d3\t\f\2\2\u00d3\64\3\2\2\2\u00d4"+
		"\u00d5\t\t\2\2\u00d5\u00d6\t\2\2\2\u00d6\66\3\2\2\2\u00d7\u00d8\t\t\2"+
		"\2\u00d8\u00d9\t\20\2\2\u00d98\3\2\2\2\u00da\u00db\t\f\2\2\u00db\u00dc"+
		"\t\n\2\2\u00dc\u00dd\t\3\2\2\u00dd\u00de\t\2\2\2\u00de:\3\2\2\2\u00df"+
		"\u00e0\t\3\2\2\u00e0\u00e1\t\6\2\2\u00e1\u00e2\t\b\2\2\u00e2\u00e3\t\3"+
		"\2\2\u00e3<\3\2\2\2\u00e4\u00e5\t\20\2\2\u00e5\u00e6\t\t\2\2\u00e6>\3"+
		"\2\2\2\u00e7\u00e8\t\4\2\2\u00e8\u00e9\t\n\2\2\u00e9\u00ea\t\t\2\2\u00ea"+
		"\u00eb\t\6\2\2\u00eb\u00ec\t\3\2\2\u00ec@\3\2\2\2\u00ed\u00ee\t\6\2\2"+
		"\u00ee\u00ef\t\16\2\2\u00ef\u00f0\t\16\2\2\u00f0\u00f1\t\21\2\2\u00f1"+
		"B\3\2\2\2\u00f2\u00f3\t\21\2\2\u00f3\u00f4\t\16\2\2\u00f4\u00f5\t\16\2"+
		"\2\u00f5\u00f6\t\6\2\2\u00f6D\3\2\2\2\u00f7\u00f8\t\5\2\2\u00f8\u00f9"+
		"\t\7\2\2\u00f9\u00fa\t\b\2\2\u00fa\u00fb\t\3\2\2\u00fbF\3\2\2\2\u00fc"+
		"\u00fd\t\3\2\2\u00fd\u00fe\t\b\2\2\u00fe\u00ff\t\7\2\2\u00ff\u0100\t\5"+
		"\2\2\u0100H\3\2\2\2\u0101\u0102\t\16\2\2\u0102\u0103\t\20\2\2\u0103J\3"+
		"\2\2\2\u0104\u0105\t\2\2\2\u0105\u0106\t\16\2\2\u0106\u0107\t\f\2\2\u0107"+
		"L\3\2\2\2\u0108\u0109\t\22\2\2\u0109N\3\2\2\2\u010a\u010b\t\23\2\2\u010b"+
		"P\3\2\2\2\u010c\u010d\t\24\2\2\u010dR\3\2\2\2\u010e\u0111\5O\'\2\u010f"+
		"\u0111\5Q(\2\u0110\u010e\3\2\2\2\u0110\u010f\3\2\2\2\u0111T\3\2\2\2\u0112"+
		"\u0113\7v\2\2\u0113\u0114\t\13\2\2\u0114\u0115\t\25\2\2\u0115\u0116\t"+
		"\3\2\2\u0116V\3\2\2\2\u0117\u0118\7h\2\2\u0118\u0119\t\7\2\2\u0119\u011a"+
		"\t\6\2\2\u011a\u011b\t\b\2\2\u011b\u011c\t\3\2\2\u011cX\3\2\2\2\u011d"+
		"\u0120\5U*\2\u011e\u0120\5W+\2\u011f\u011d\3\2\2\2\u011f\u011e\3\2\2\2"+
		"\u0120Z\3\2\2\2\u0121\u0123\5M&\2\u0122\u0121\3\2\2\2\u0123\u0124\3\2"+
		"\2\2\u0124\u0122\3\2\2\2\u0124\u0125\3\2\2\2\u0125\\\3\2\2\2\u0126\u012c"+
		"\5Q(\2\u0127\u012b\7a\2\2\u0128\u012b\5S)\2\u0129\u012b\5M&\2\u012a\u0127"+
		"\3\2\2\2\u012a\u0128\3\2\2\2\u012a\u0129\3\2\2\2\u012b\u012e\3\2\2\2\u012c"+
		"\u012a\3\2\2\2\u012c\u012d\3\2\2\2\u012d\u0131\3\2\2\2\u012e\u012c\3\2"+
		"\2\2\u012f\u0131\5c\61\2\u0130\u0126\3\2\2\2\u0130\u012f\3\2\2\2\u0131"+
		"^\3\2\2\2\u0132\u0138\5O\'\2\u0133\u0137\7a\2\2\u0134\u0137\5S)\2\u0135"+
		"\u0137\5M&\2\u0136\u0133\3\2\2\2\u0136\u0134\3\2\2\2\u0136\u0135\3\2\2"+
		"\2\u0137\u013a\3\2\2\2\u0138\u0136\3\2\2\2\u0138\u0139\3\2\2\2\u0139\u013d"+
		"\3\2\2\2\u013a\u0138\3\2\2\2\u013b\u013d\5a\60\2\u013c\u0132\3\2\2\2\u013c"+
		"\u013b\3\2\2\2\u013d`\3\2\2\2\u013e\u013f\7u\2\2\u013f\u0140\7g\2\2\u0140"+
		"\u0141\7n\2\2\u0141\u0142\7h\2\2\u0142b\3\2\2\2\u0143\u0144\7U\2\2\u0144"+
		"\u0145\7G\2\2\u0145\u0146\7N\2\2\u0146\u0147\7H\2\2\u0147\u0148\7a\2\2"+
		"\u0148\u0149\7V\2\2\u0149\u014a\7[\2\2\u014a\u014b\7R\2\2\u014b\u014c"+
		"\7G\2\2\u014cd\3\2\2\2\u014d\u014f\t\26\2\2\u014e\u014d\3\2\2\2\u014f"+
		"\u0150\3\2\2\2\u0150\u014e\3\2\2\2\u0150\u0151\3\2\2\2\u0151\u0152\3\2"+
		"\2\2\u0152\u0153\b\62\2\2\u0153f\3\2\2\2\u0154\u0158\5i\64\2\u0155\u0158"+
		"\5k\65\2\u0156\u0158\5m\66\2\u0157\u0154\3\2\2\2\u0157\u0155\3\2\2\2\u0157"+
		"\u0156\3\2\2\2\u0158\u0159\3\2\2\2\u0159\u015a\b\63\3\2\u015ah\3\2\2\2"+
		"\u015b\u0161\7$\2\2\u015c\u015d\7^\2\2\u015d\u0160\13\2\2\2\u015e\u0160"+
		"\n\27\2\2\u015f\u015c\3\2\2\2\u015f\u015e\3\2\2\2\u0160\u0163\3\2\2\2"+
		"\u0161\u0162\3\2\2\2\u0161\u015f\3\2\2\2\u0162\u0164\3\2\2\2\u0163\u0161"+
		"\3\2\2\2\u0164\u0165\7$\2\2\u0165j\3\2\2\2\u0166\u016c\7$\2\2\u0167\u0168"+
		"\7^\2\2\u0168\u016b\13\2\2\2\u0169\u016b\n\27\2\2\u016a\u0167\3\2\2\2"+
		"\u016a\u0169\3\2\2\2\u016b\u016e\3\2\2\2\u016c\u016d\3\2\2\2\u016c\u016a"+
		"\3\2\2\2\u016d\u016f\3\2\2\2\u016e\u016c\3\2\2\2\u016f\u0170\7\f\2\2\u0170"+
		"l\3\2\2\2\u0171\u0177\7$\2\2\u0172\u0173\7^\2\2\u0173\u0176\13\2\2\2\u0174"+
		"\u0176\n\27\2\2\u0175\u0172\3\2\2\2\u0175\u0174\3\2\2\2\u0176\u0179\3"+
		"\2\2\2\u0177\u0178\3\2\2\2\u0177\u0175\3\2\2\2\u0178\u017b\3\2\2\2\u0179"+
		"\u0177\3\2\2\2\u017a\u017c\7^\2\2\u017b\u017a\3\2\2\2\u017b\u017c\3\2"+
		"\2\2\u017c\u017d\3\2\2\2\u017d\u017e\7\2\2\3\u017en\3\2\2\2\u017f\u0180"+
		"\13\2\2\2\u0180\u0181\b\67\4\2\u0181p\3\2\2\2\u0182\u0183\7/\2\2\u0183"+
		"\u0184\7/\2\2\u0184\u0188\3\2\2\2\u0185\u0187\13\2\2\2\u0186\u0185\3\2"+
		"\2\2\u0187\u018a\3\2\2\2\u0188\u0189\3\2\2\2\u0188\u0186\3\2\2\2\u0189"+
		"\u018c\3\2\2\2\u018a\u0188\3\2\2\2\u018b\u018d\t\30\2\2\u018c\u018b\3"+
		"\2\2\2\u018d\u018e\3\2\2\2\u018e\u018f\b8\2\2\u018fr\3\2\2\2\u0190\u0191"+
		"\7,\2\2\u0191\u0192\7+\2\2\u0192\u0194\3\2\2\2\u0193\u0195\7\2\2\3\u0194"+
		"\u0193\3\2\2\2\u0194\u0195\3\2\2\2\u0195\u0196\3\2\2\2\u0196\u0197\b9"+
		"\5\2\u0197t\3\2\2\2\u0198\u0199\7*\2\2\u0199\u019a\7,\2\2\u019a\u019b"+
		"\3\2\2\2\u019b\u019c\7\2\2\3\u019c\u019d\b:\6\2\u019dv\3\2\2\2\u019e\u019f"+
		"\7*\2\2\u019f\u01a0\7,\2\2\u01a0\u01a1\3\2\2\2\u01a1\u01a2\b;\7\2\u01a2"+
		"\u01a3\b;\2\2\u01a3x\3\2\2\2\u01a4\u01a5\13\2\2\2\u01a5\u01a6\7\2\2\3"+
		"\u01a6\u01a7\b<\b\2\u01a7z\3\2\2\2\u01a8\u01a9\7*\2\2\u01a9\u01aa\7,\2"+
		"\2\u01aa\u01ab\3\2\2\2\u01ab\u01ac\b=\t\2\u01ac\u01ad\b=\2\2\u01ad|\3"+
		"\2\2\2\u01ae\u01af\7,\2\2\u01af\u01b0\7+\2\2\u01b0\u01b1\3\2\2\2\u01b1"+
		"\u01b2\b>\n\2\u01b2\u01b3\b>\2\2\u01b3~\3\2\2\2\u01b4\u01b5\13\2\2\2\u01b5"+
		"\u01b6\3\2\2\2\u01b6\u01b7\b?\2\2\u01b7\u0080\3\2\2\2\u01b8\u01b9\7*\2"+
		"\2\u01b9\u01ba\7,\2\2\u01ba\u01bb\3\2\2\2\u01bb\u01bc\7\2\2\3\u01bc\u01bd"+
		"\b@\13\2\u01bd\u0082\3\2\2\2\u01be\u01bf\13\2\2\2\u01bf\u01c0\7\2\2\3"+
		"\u01c0\u01c1\bA\f\2\u01c1\u0084\3\2\2\2\u01c2\u01c3\7*\2\2\u01c3\u01c4"+
		"\7,\2\2\u01c4\u01c5\3\2\2\2\u01c5\u01c6\bB\t\2\u01c6\u01c7\bB\2\2\u01c7"+
		"\u0086\3\2\2\2\u01c8\u01c9\7,\2\2\u01c9\u01ca\7+\2\2\u01ca\u01cb\3\2\2"+
		"\2\u01cb\u01cc\7\2\2\3\u01cc\u01cd\bC\r\2\u01cd\u0088\3\2\2\2\u01ce\u01cf"+
		"\7,\2\2\u01cf\u01d0\7+\2\2\u01d0\u01d1\3\2\2\2\u01d1\u01d2\bD\n\2\u01d2"+
		"\u01d3\bD\2\2\u01d3\u008a\3\2\2\2\u01d4\u01d5\13\2\2\2\u01d5\u01d6\3\2"+
		"\2\2\u01d6\u01d7\bE\2\2\u01d7\u008c\3\2\2\2\33\2\3\4\u0110\u011f\u0124"+
		"\u012a\u012c\u0130\u0136\u0138\u013c\u014e\u0150\u0157\u015f\u0161\u016a"+
		"\u016c\u0175\u0177\u017b\u0188\u018c\u0194\16\b\2\2\3\63\2\3\67\3\39\4"+
		"\3:\5\7\3\2\3<\6\7\4\2\6\2\2\3@\7\3A\b\3C\t";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}