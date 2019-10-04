all: testParser.class

testParser.class:
	java -cp antlr-3.5.2-complete.jar org.antlr.Tool myparser.g
	javac -cp ./antlr-3.5.2-complete.jar testParser.java myparserParser.java myparserLexer.java

test1:
	java -cp ./antlr-3.5.2-complete.jar:. testParser helloworld.c

test2:
	java -cp ./antlr-3.5.2-complete.jar:. testParser fibonacci.c

test3:
	java -cp ./antlr-3.5.2-complete.jar:. testParser grade.c

clean:
	rm myparserLexer.java myparserParser.java *.tokens *.class
