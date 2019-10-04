grammar myInterp;

options {
	language = Java;
}

@header {
	import java.util.HashMap;
        import java.util.Scanner;
}

@members {
	//Determine if this statement is to be executed
	boolean flag = true;
	
	//Check if printf has a second parameter
	boolean print_para = false;
	
	//Store the first parameter of printf and scanf
	String content;
	
	Scanner scanner = new Scanner(System.in);
	HashMap<String, Integer> int_memory = new HashMap<String, Integer>();
	HashMap<String, Float> float_memory = new HashMap<String, Float>();
	
	//Store the type of comparison
	int compare_type;
}


/*------------*/
/*   Parser   */
/*------------*/

/*------------------------------------------*/
/* Match the include file and main function */
/*------------------------------------------*/

program : (POUND INCLUDE '<' HEADER '>')* main_function ;


/*-------------------------------------------*/
/* There are many rows in the main function. */
/* Including declarations and statements.    */
/*-------------------------------------------*/

main_function : (VOID_TYPE | INT_TYPE) MAIN '(' ')' '{' declarations* statement* '}' ;


/*-----------------------------------------------------*/
/* Declare variables , Types include int, float        */
/* Can nott give value at the same time when declaring */
/*-----------------------------------------------------*/

declarations : INT_TYPE a=ID { int_memory.put($a.text, 0); } ';' 
			 | FLOAT_TYPE b=ID { float_memory.put($b.text, (float)0.0); } ';' ;


/*-------------------------------------------------------------------*/
/* Narrated statements                                               */
/* Include : comparison, assignment, function, if_else, return_value */
/*-------------------------------------------------------------------*/

statement : comparison_statement ';'
          | assign_statement ';'
		  | printf_function
		  | scanf_function
          | IF '(' comparison_statement ')' if_loop_statements ELSE else_loop_statements {flag = true;}
          | RETURN (arith_expression)? ';' ;


comparison_statement 
		: a = arith_expression  
		  ( EQ_OP { compare_type = 1; }
            |NE_OP { compare_type = 2; }
		    |GT_OP { compare_type = 3; }
		    |GE_OP { compare_type = 4; }
		    |LT_OP { compare_type = 5; }
	 	    |LE_OP { compare_type = 6; } ) 
		  b = arith_expression 
		  { if ( compare_type == 1 ) flag = ($a.int_value == $b.int_value) ;
		    if ( compare_type == 2 ) flag = ($a.int_value != $b.int_value) ;
		    if ( compare_type == 3 ) flag = ($a.int_value > $b.int_value) ;
		    if ( compare_type == 4 ) flag = ($a.int_value >= $b.int_value) ;
		    if ( compare_type == 5 ) flag = ($a.int_value < $b.int_value) ;
		    if ( compare_type == 6 ) flag = ($a.int_value <= $b.int_value) ; };


assign_statement : ID '=' arith_expression
		   { if(flag) 
			if($arith_expression.type==0)
				int_memory.put($ID.text, $arith_expression.int_value);
			else
				float_memory.put($ID.text, $arith_expression.float_value); };

/*---------------------------------------------------------------*/
/* The implementation of printf function and scanf function      */
/* The printf received parameters can have one or two            */
/* The scanf received parameters can only have two               */
/*---------------------------------------------------------------*/

printf_function : PRINTF '(' STRING (',' ID {print_para = true;})?
		  { content = $STRING.text; 
		    content = content.substring(1, content.length()-1);
                    content = content.replace("\\n", "");
		    if (print_para)
			if(content.indexOf("\%d")>=0)
                        	content = content.replace("\%d", Integer.toString(((Integer)int_memory.get($ID.text)).intValue()));
			else
                        	content = content.replace("\%f", Float.toString(((Float)float_memory.get($ID.text)).floatValue()));
		    if(flag) 
			System.out.println(content);}
                  ')' ';' {print_para = false;};

scanf_function : SCANF '(' STRING ',' '&'ID ')' ';'
                 {if(flag) {
			content = $STRING.text;
		  	if(content.indexOf("\%d")>=0)
				int_memory.put($ID.text, scanner.nextInt());
		 	else
				float_memory.put($ID.text, scanner.nextFloat()); }; };
			


if_loop_statements
	        : statement
                | '{' statement+ '}';

else_loop_statements
		: {flag = !flag;}
	          (statement
                | '{' statement+ '}');


/*----------------------------------------------------------------------------------------------------------------*/
/* Simple arithmetic operate                                                                                      */
/* The return value is the value of an integer, the value of a floating point number, and the true type of value  */
/*----------------------------------------------------------------------------------------------------------------*/

arith_expression 
returns [int int_value , float float_value , int type]
           : a = multExpr { $int_value = $a.int_value ; $float_value = $a.float_value ; $type = $a.type; }
             ( '+' b = multExpr {if($a.type==1 || $b.type==1) 
					{ $float_value = $float_value + $b.float_value ; $type = 1; }
				 else
					 $int_value = $int_value + $b.int_value;}
             | '-' c = multExpr {if($a.type==1 || $c.type==1) 
					{ $float_value = $float_value - $c.float_value ; $type = 1; }
				 else
					 $int_value = $int_value - $b.int_value;} )*;

multExpr 
returns [int int_value , float float_value , int type]
           : a = signExpr { $int_value = $a.int_value ; $float_value = $a.float_value ; $type = $a.type; }
             ( '*' b = signExpr {if($a.type==1 || $b.type==1) 
					{ $float_value = $float_value * $b.float_value ; $type = 1; }
				 else
					 $int_value = $int_value * $b.int_value;} 
             | '/' c = signExpr {if($a.type==1 || $c.type==1) 
					{ $float_value = $float_value / $b.float_value ; $type = 1; }
				 else
					 $int_value = $int_value / $b.int_value;} )*;

signExpr 
returns [int int_value , float float_value , int type]
           : a = primaryExpr { $int_value = $a.int_value ; $float_value = $a.float_value ; $type = $a.type; }
             | '-' b = primaryExpr { $int_value = (-1) * $b.int_value ; $float_value = (float)(-1) * $b.float_value ; $type = $b.type; } ;
		  
primaryExpr 
returns [int int_value , float float_value , int type]
	   : DEC_NUM 
             { $int_value = Integer.parseInt($DEC_NUM.text) ; $float_value = (float)Integer.parseInt($DEC_NUM.text) ; $type = 0; }
	   | FLOAT_NUM
	     { $int_value = (int)Float.parseFloat($FLOAT_NUM.text) ; $float_value = Float.parseFloat($FLOAT_NUM.text) ; $type = 1; }
           | ID
	     { Integer v = (Integer)int_memory.get($ID.text);
	       if (v != null) 
	           {$int_value = v.intValue() ; $float_value = (float)v.intValue() ; $type = 0; };
	       Float w = (Float)float_memory.get($ID.text);
	       if (w != null) 
	           {$int_value = (int)w.floatValue() ; $float_value = w.floatValue() ; $type = 1; }; }
           | '(' arith_expression ')' 
             { $int_value = $arith_expression.int_value ; $float_value = $arith_expression.float_value ; $type = $arith_expression.type; } ;




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

COMMENT1 : '//'(.)*'\n' {skip();} ;
COMMENT2 : '/*' (options{greedy=false;}: .)* '*/' {skip();} ;

/*----------*/
/*  Number  */
/*----------*/

DEC_NUM : ('0' | ('1'..'9')(DIGIT)*) ;
FLOAT_NUM: FLOAT_NUM1 | FLOAT_NUM2 | FLOAT_NUM3 ;

/*--------------*/
/*  Identifier  */
/*--------------*/

HEADER  : (LETTER)+'.h' ;

/*----------*/
/*  String  */
/*----------*/

STRING  : '"'.*'"' ;
INCLUDE : 'include' ;
RETURN  : 'return' ;

/*------------*/
/*  function  */
/*------------*/

MAIN   : 'main' ;
PRINTF : 'printf' ;
SCANF  : 'scanf' ;

/*--------------*/
/*  Identifier  */
/*--------------*/

ID : (LETTER)(LETTER | DIGIT)*;

/*--------------------------*/
/*  White space or Newline  */
/*--------------------------*/

NEW_LINE: '\r'? '\n' {skip();} ;
WS  : (' '|'\t')+ {skip();} ;

fragment FLOAT_NUM1: (DIGIT)+'.'(DIGIT)*;
fragment FLOAT_NUM2: '.'(DIGIT)+;
fragment FLOAT_NUM3: (DIGIT)+;
fragment LETTER : 'a'..'z' | 'A'..'Z' | '_';
fragment DIGIT : '0'..'9';
