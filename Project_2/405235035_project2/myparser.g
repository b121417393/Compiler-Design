grammar myparser;

options {
  language = Java;
}

@members {
    boolean TRACEON = true;
}


/*------------*/
/*   Parser   */
/*------------*/

/*------------------------------------------*/
/* Match the include file and main function */
/*------------------------------------------*/

program : (POUND INCLUDE 
	  {if (TRACEON) System.out.println("match #include <XXXX.h>");} '<' HEADER '>')*
          main_function;


/*-------------------------------------------*/
/* There are many rows in the main function. */
/* Including declarations and statements.    */
/*-------------------------------------------*/

main_function : (VOID_TYPE | INT_TYPE) MAIN 
		{if (TRACEON) System.out.println("match main function");}
		'(' ')' '{' declarations statements '}';


/*------------------------------------------------*/
/* Declare variables                              */
/* Types include int, float, char                 */
/* Can give value at the same time when declaring */
/*------------------------------------------------*/

declarations : (type ID ('=' (DEC_NUM|FLOAT_NUM))? (',' ID ('=' (DEC_NUM|FLOAT_NUM))? )* ';')* ;

type : INT_TYPE   {if (TRACEON) System.out.println("match type:int has been declarations"); }
     | FLOAT_TYPE {if (TRACEON) System.out.println("match type:float has been declarations"); }
     | VOID_TYPE  {if (TRACEON) System.out.println("match type:void has been declarations"); }
     | CHAR_TYPE  {if (TRACEON) System.out.println("match type:char has been declarations"); };


/*-----------------------------------------------------------------------------------------*/
/* Narrated statements                                                                     */
/* Include : comparison, assignment, function, if_else, for_loop, while_loop, return_value */
/*-----------------------------------------------------------------------------------------*/

statements : (statement)+;

statement : comparison_statement ';'
          | assign_statement ';'
	  | printf_function 
	    {if (TRACEON) System.out.println("match printf function"); }
          | IF {if (TRACEON) System.out.println("match if else statement"); }
	    '(' comparison_statement ')' loop_statements ELSE loop_statements
          | FOR {if (TRACEON) System.out.println("match for loop"); }
	    '(' assign_statement? ';' comparison_statement? ';' assign_statement? ')' loop_statements 
          | WHILE {if (TRACEON) System.out.println("match while loop"); }
	    '(' comparison_statement ')' loop_statements
          | RETURN arith_expression ';'
	    {if (TRACEON) System.out.println("match return value"); };


comparison_statement : arith_expression (EQ_OP|NE_OP|GT_OP|GE_OP|LT_OP|LE_OP) arith_expression
                       {if (TRACEON) System.out.println("match comparison statement"); };


assign_statement : ID '=' arith_expression 
	           {if (TRACEON) System.out.println("match assign statement"); }
                 | ID ( INCRE_OP | DECRE_OP ) 
	           {if (TRACEON) System.out.println("match ++ or -- statement"); }
                 | ID ( PLUS_OP | MINUS_OP ) arith_expression
	           {if (TRACEON) System.out.println("match += or -= statement"); };

/*-----------------------------------------------------*/
/* The implementation of printf function               */
/* The received parameters can have one or two or more */
/*-----------------------------------------------------*/

printf_function : PRINTF '(' STRING (',' ID)* ')' ';';

loop_statements : statement
                | '{' statements '}';


/*---------------------------*/
/* Simple arithmetic operate */
/*---------------------------*/

arith_expression : multExpr ( '+' multExpr | '-' multExpr)*;

multExpr : signExpr ( '*' signExpr | '/' signExpr | '%' signExpr | '>>' signExpr | '<<' signExpr )*;

signExpr : primaryExpr | '-' primaryExpr;
		  
primaryExpr: DEC_NUM
           | FLOAT_NUM
           | ID
           | '(' arith_expression ')';





/*-------------*/
/*   Scanner   */
/*-------------*/

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
PLUS_OP   : '+=';
MINUS_OP  : '-=';
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

COMMENT1 : '//'(.)*'\n' {skip();};
COMMENT2 : '/*' (options{greedy=false;}: .)* '*/' {skip();};

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
RETURN  : 'return';

/*------------*/
/*  function  */
/*------------*/

MAIN   : 'main';
PRINTF : 'printf';

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
