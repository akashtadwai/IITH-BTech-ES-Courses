<!-- This is a markdown formatted file please view it with .md viewer in any text editor -->
<!-- Or just copy paste this whole thing https://stackedit.io/app#    -->

# COOL COMPILER

## Structure

The lexer implemented is able to extract the following structures in *COOL* and the order in which they are tokenised are as follows:

1. **_Operators_**
2. **_Keywords_**
3. **_Identifiers_**
4. **_Strings and WhiteSpaces_**
5. **_Comments_**
6. **_Remaining Non-valid Characters_**

**NOTE** : I was not able to handle the line numbers properly. All the errors are handled properly

--------------------------------
                                                    Design Rules
--------------------------------

**_Comments_**

COOL has two forms of comments: Line and Block.
Line comments are simple to handle, but care must be taken with the Block comments as they are nested. To handle Block comments one might use a recursive expression or a stack in Antlr to check the level of nesting.

- If "--" is encountered, it means it is a single line comment. Encountering an EOF in a single line comment is not considered an erroneous case.

- When "(\*" is encountered during, we enter the comment state. When EOF is encountered in comment state, error is reported. A comment ends when it encounters "*)".

- When only '\*)' is present it is reported as*unmatched '\*)'*
<br> </br>

**_Strings_**

Strings are enclosed in double quotes "...". Within a string, a sequence ‘\c’ denotes the character ‘c’, with the exception of the following:

- \b -> backspace
- \t -> tab
- \n -> newline
- \f -> formfeed  

### Error Checking in Strings

1. When String length exceeds 1024 Error is reported and there are some corner cases which are desribed as:  
    - If there are 1024/1025 characters and NULL character at ending of string and string is terminated, Error is reported as **__string contains null character__** and if >1026 characters it is reported as string is too long.
    - If there are 1024 characters and last character is unescaped newline it is reported as **__Unterminated string constant__**
2. Report error if null character is encountered.
3. When an escape is followed by a new line, just add a \n to the string.
4. When a new line is encountered without an escape, report error.
5. If EOF is encountered, return error.
    - If last character is an unescaped backslash then it is reported as **__backslash at end of file__**.
    - If there is no unescaped backslash then it is reported as normal EOF.
6. Different error messages are provided for different errors.

## Key Words  

All the keywords except true and false, are case insensitive, so we write the rule as:  

```CLASS : ('c'|'C')('l'|'L')('a'|'A')('s'|'S')('s'|'S');```

And for true and false whose first character is case sensitive and must be lower case, we use the following definitions:  

```true  : 't'('r'|'R')('u'|'U')('e'|'E');``` 

```false : 'f'('a'|'A')('l'|'L')('s'|'S')('e'|'E');```  

## Identifiers  

Type identifiers begin with a capital letter, object identifiers begin with a lower case letter, so we define them as follows:  

```TYPEID   : ULETTER('_'|LETTER|DIGIT)*;```
```OBJECTID : LLETTER('_'|LETTER|DIGIT)*;```

## Operators  

For special notaitons, we use:

```DARROW      =>```  

```ASSIGN      <-```  

```LE    <=```  

```OPERATOR    "{"|"}"|","|":"|"."|"@"|"+"|"-"|"*"|"/"|"~"|"<"|"="|"("|")" |"; "```

If an input cannot be matched to any of the above rules, an error message will be generated.  

## Testing  

I have conducted many tests on my code. Some tests are provided for verification purpose.
Heavy tests are conducted on strings, to ensure correctness.
Some example files from cs164 (stanford compilers) are used test other ascepts like int identifiers, keywords, special symbols etc.