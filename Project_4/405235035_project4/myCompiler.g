grammar myCompiler;

options {
	language = Java;
}

@header {
	import java.util.HashMap;
	import java.util.ArrayList;
	import java.util.Scanner;
}

@members {

	HashMap<String, ArrayList> symtab = new HashMap<String, ArrayList>();
	HashMap<String, Integer> int_memory = new HashMap<String, Integer>();
	HashMap<String, Float> float_memory = new HashMap<String, Float>();

	String content;
	boolean print_para = false;

	int labelCount = 0;
	int storageIndex = 0;

	List<String> TextCode = new ArrayList<String>();

	public enum Type{
		INT, FLOAT ;
	}


	void prologue()
	{
		TextCode.add(".source noSource");
		TextCode.add(".class public static result");
		TextCode.add(".super java/lang/Object");
		TextCode.add(".method public static main([Ljava/lang/String;)V");
		TextCode.add("");
		/* The size of stack and locals should be properly set. */
		TextCode.add(".limit stack 100");
		TextCode.add(".limit locals 100");
		TextCode.add("");
	}

	void epilogue()
	{
		/* handle epilogue */
		TextCode.add("");
		TextCode.add("return");
		TextCode.add(".end method");
	}

	String newLabel()
	{
		labelCount ++;
		return (new String("L")) + Integer.toString(labelCount);
	}

	String thenLabel()
	{
		return (new String("L")) + Integer.toString(labelCount-1);
	} 

	String endLabel()
	{
		return (new String("L")) + Integer.toString(labelCount);
	} 

	public List<String> getTextCode()
	{
		return TextCode;
	}

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

main_function : (VOID_TYPE | INT_TYPE) MAIN '(' ')' 
	        { prologue(); }
		'{' declarations* statement* '}' 
		{ epilogue(); } ;


/*-----------------------------------------------------*/
/* Declare variables , Types include int, float        */
/* Can not give value at the same time when declaring  */
/*-----------------------------------------------------*/

declarations : type ID ';'
	       { if ( $type.attr_type == Type.INT)
			int_memory.put($ID.text, 0);
		 else
			float_memory.put($ID.text, (float)0.0);

		 ArrayList the_list = new ArrayList<>();
	         the_list.add($type.attr_type);
	         the_list.add(storageIndex);
		 storageIndex = storageIndex + 1;
                 symtab.put($ID.text, the_list); } ;


type
returns [Type attr_type]
    	: INT_TYPE { $attr_type=Type.INT; }
    	| FLOAT_TYPE { $attr_type=Type.FLOAT; }
	;



/*-------------------------------------------------------------------*/
/* Narrated statements                                               */
/* Include : comparison, assignment, function, if_else, return_value */
/*-------------------------------------------------------------------*/

statement : assign_statement ';'
	  | printf_function
          | IF '(' a=arith_expression c=comparison_operation b=arith_expression ')' 
	    { if($a.attr_type == Type.INT)
		TextCode.add("\tlcmp"); 
	      else
		TextCode.add("\tfcmpl"); 

	      if($c.opcode == 0)
		TextCode.add("\tifne " + newLabel()); 
	      else if($c.opcode == 1)
		TextCode.add("\tifeq " + newLabel()); 
	      else if($c.opcode == 3)
		TextCode.add("\tiflt " + newLabel()); 
	      else if($c.opcode == 5)
		TextCode.add("\tifgt " + newLabel()); 
	      else if($c.opcode == 2)
		TextCode.add("\tifle " + newLabel()); 
	      else if($c.opcode == 4)
		TextCode.add("\tifge " + newLabel());
}
	    then_statements
	    {TextCode.add("\tgoto " + newLabel()) ;}
	    ELSE 
            {TextCode.add(thenLabel() + ":") ;}
            else_statements
	    {TextCode.add(endLabel() + ":") ;}

          | RETURN (arith_expression)? ';' ;

comparison_operation
returns [int opcode]
		: EQ_OP {$opcode = 0;}
                | NE_OP {$opcode = 1;}
		| GT_OP {$opcode = 2;}
		| GE_OP {$opcode = 3;}
		| LT_OP {$opcode = 4;}
	 	| LE_OP {$opcode = 5;} ;


assign_statement : ID '=' arith_expression
             	   {
		   	Type the_type;
		   	int the_mem;
			   
		   	// get the ID's location and type from symtab.			   
		   	the_type = (Type) symtab.get($ID.text).get(0);
		   	the_mem = (int) symtab.get($ID.text).get(1);
			
		   	// issue store insruction:
		   	// => store the top element of the operand stack into the locals.
		   	switch (the_type)
		   	{
		   		case INT:
					int_memory.put($ID.text, $arith_expression.int_value);
		   			TextCode.add("\tistore " + the_mem);
		   			break;
		   		case FLOAT:
					float_memory.put($ID.text, $arith_expression.float_value);
					TextCode.add("\tfstore " + the_mem);
		   			break;
		   	}
                   } ;


/*---------------------------------------------------------------*/
/* The implementation of printf function and scanf function      */
/* The printf received parameters can have one or two            */
/* The scanf received parameters can only have two               */
/*---------------------------------------------------------------*/

printf_function : PRINTF '(' STRING (',' '&' ID {print_para = true;} )? ')' ';' 
		  { content = $STRING.text; 
		    content = content.substring(1, content.length()-1);
                    content = content.replace("\\n", "");
		    
		    if (print_para)
		    	if(content.indexOf("\%d")>=0)
                    		content = content.replace("\%d", Integer.toString(((Integer)int_memory.get($ID.text)).intValue()));
		    	else
                        	content = content.replace("\%f", Float.toString(((Float)float_memory.get($ID.text)).floatValue()));

		    TextCode.add("\tgetstatic java/lang/System/out Ljava/io/PrintStream;");
		    TextCode.add("\tldc " + "\"" + content + "\"");
		    TextCode.add("\tinvokevirtual java/io/PrintStream/println(Ljava/lang/String;)V");
		  }
		  {print_para = false;};

then_statements
	        : statement
                | '{' statement+ '}';

else_statements
		: statement
                | '{' statement+ '}';


/*----------------------------------------------------------------------------------------------------------------*/
/* Simple arithmetic operate                                                                                      */
/* The return value is the value of an integer, the value of a floating point number, and the true type of value  */
/*----------------------------------------------------------------------------------------------------------------*/

arith_expression 
returns [int int_value , float float_value , Type attr_type , String txt]
           : a = multExpr { $int_value = $a.int_value ; $float_value = $a.float_value ; $attr_type = $a.attr_type; $txt = $a.txt; }
             ( '+' b = multExpr 
             { if (($attr_type == Type.INT) && ($b.attr_type == Type.INT)){
			$int_value = $int_value + $b.int_value ;
	       		TextCode.add("\tiadd");}
	       else{
			$float_value = $float_value + $b.float_value;
			TextCode.add("\tfadd");}
	     }

           | '-' c = multExpr 
             { if (($attr_type == Type.INT) && ($b.attr_type == Type.INT)){
			$int_value = $int_value - $b.int_value ;
	       		TextCode.add("\tisub");}
	       else{
			$float_value = $float_value - $b.float_value;
			TextCode.add("\tfsub");}
	     } 
	   )*;

multExpr 
returns [int int_value , float float_value , Type attr_type , String txt ]
           : a = signExpr { $int_value = $a.int_value ; $float_value = $a.float_value ; $attr_type = $a.attr_type ; $txt = $a.txt; }
             ( '*' b = signExpr 
	     { if (($attr_type == Type.INT) && ($b.attr_type == Type.INT)){
			$int_value = $int_value * $b.int_value ;
	       		TextCode.add("\timul");}
	       else{
			$float_value = $float_value * $b.float_value ;
			TextCode.add("\tfmul");}
	     }
           | '/' c = signExpr 
	     { if (($attr_type == Type.INT) && ($b.attr_type == Type.INT)){
			$int_value = $int_value / $b.int_value ;
	       		TextCode.add("\tidiv");}
	       else{
			$float_value = $float_value / $b.float_value ;
			TextCode.add("\tfdiv");}
	     }
           )*;

signExpr 
returns [int int_value , float float_value , Type attr_type , String txt ]
           : a = primaryExpr { $int_value = $a.int_value ; $float_value = $a.float_value ; $attr_type = $a.attr_type ; $txt = $a.txt; }
           | '-' b = primaryExpr { $int_value = (-1) * $b.int_value ; $float_value = (float)(-1) * $b.float_value ; $attr_type = $a.attr_type ; $txt = $a.txt;}
             { if ($attr_type == Type.INT)
	       		TextCode.add("\tineg");
	       else
			TextCode.add("\tfneg");
             } ;
		  
primaryExpr 
returns [int int_value , float float_value , Type attr_type , String txt]
	   : DEC_NUM 
             { $attr_type = Type.INT;
	       $txt = $DEC_NUM.text;
	       $int_value = Integer.parseInt($DEC_NUM.text) ; 
	       $float_value = (float)Integer.parseInt($DEC_NUM.text) ;		
	       // code generation.
	       // push the integer into the operand stack.
	       TextCode.add("\tldc " + $DEC_NUM.text); }

	   | FLOAT_NUM
             { $attr_type = Type.FLOAT;
	       $txt = $FLOAT_NUM.text;
	       $int_value = (int)Float.parseFloat($FLOAT_NUM.text) ; 
               $float_value = Float.parseFloat($FLOAT_NUM.text) ;
	       // code generation.
	       // push the integer into the operand stack.
	       TextCode.add("\tldc " + $FLOAT_NUM.text); }

           | ID
	     {
	       $txt = $ID.text;
	       Integer v = (Integer)int_memory.get($ID.text);
	       	if (v != null) 
	           {$int_value = v.intValue() ; $float_value = (float)v.intValue() ;};
	       Float w = (Float)float_memory.get($ID.text);
	       	if (w != null) 
	           {$int_value = (int)w.floatValue() ; $float_value = w.floatValue() ;};


		// get type information from symtab.
		$attr_type = (Type) symtab.get($ID.text).get(0);
				
		switch ($attr_type) {
			case INT: 
				// load the variable into the operand stack.
				TextCode.add("\tiload " + symtab.get($ID.text).get(1));
				break;
			case FLOAT:
				TextCode.add("\tfload " + symtab.get($ID.text).get(1));
				break;			
		}
	     }

           | '(' arith_expression ')' 
             { $int_value = $arith_expression.int_value ; $float_value = $arith_expression.float_value ; $attr_type = $arith_expression.attr_type ; $txt = $arith_expression.text ;} ;



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
