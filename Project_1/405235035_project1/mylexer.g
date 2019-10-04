lexer grammar mylexer;

options {
  language = Java;
}

	/*-------------*/
	/*  Data type  */
	/*-------------*/

VOID_TYPE  : 'void';
INT_TYPE   : 'int';
FLOAT_TYPE : 'float';
CHAR_TYPE  : 'char';

	/*------------------------*/
	/*  program control flow  */
	/*------------------------*/

IF    : 'if';
ELSE  : 'else';
WHILE : 'while';
DO    : 'do';
FOR   : 'for';

	/*------------------------*/
	/*  Arithmetic operators  */
	/*------------------------*/

ADD_OP    : '+';
SUB_OP    : '-';
MUL_OP    : '*';
DIV_OP    : '/';
MOD_OP    : '%';
ASSIGN_OP : '=';
INCRE_OP  : '++';
DECRE_OP  : '--';
RSHIFT_OP : '<<';
LSHIFT_OP : '>>';

	/*---------------------*/
	/*  Logical operators  */
	/*---------------------*/

NEG_OP : '!';
AND_OP : '&&';
OR_OP  : '||';

	/*------------------------*/
	/*  Comparison operators  */
	/*------------------------*/

EQ_OP : '==';
NE_OP : '!=';
GT_OP : '>';
GE_OP : '>=';
LE_OP : '<=';
LT_OP : '<';

/*-------------*/
/*  Separator  */
/*-------------*/

LPAREN    : '(';
RPAREN    : ')';
LBRACKET  : '[';
RBRACKET  : ']';
LBRACE    : '{';
RBRACE    : '}';
SEMICOLON : ';';
COMMA     : ',';
COLON     : ':';
POUND     : '#';
REFERENCE : '&';

/*-----------*/
/*  Comment  */
/*-----------*/

COMMENT1 : '//'(.)*'\n';
COMMENT2 : '/*' (options{greedy=false;}: .)* '*/';

/*----------*/
/*  Number  */
/*----------*/

DEC_NUM : ('0' | ('1'..'9')(DIGIT)*);
FLOAT_NUM: FLOAT_NUM1 | FLOAT_NUM2 | FLOAT_NUM3;

/*--------------*/
/*  Identifier  */
/*--------------*/

HEADER  : (LETTER)+'.h';

/*----------*/
/*  String  */
/*----------*/

STRING  : '"'.*'"';
INCLUDE : 'include';
ENDFILE : 'EOF';

/*-----------------*/
/*  Main function  */
/*-----------------*/

MAIN : 'main';

/*--------------*/
/*  Identifier  */
/*--------------*/

ID : (LETTER)(LETTER | DIGIT)*;

/*--------------------------*/
/*  White space or Newline  */
/*--------------------------*/

NEW_LINE: '\n' {skip();} ;
WS  : (' '|'\r'|'\t')+ {skip();} ;

fragment FLOAT_NUM1: (DIGIT)+'.'(DIGIT)*;
fragment FLOAT_NUM2: '.'(DIGIT)+;
fragment FLOAT_NUM3: (DIGIT)+;
fragment LETTER : 'a'..'z' | 'A'..'Z' | '_';
fragment DIGIT : '0'..'9';
