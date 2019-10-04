all: myInterp_test.class

myInterp_test.class:
	java -cp antlr-3.5.2-complete.jar org.antlr.Tool myInterp.g
	javac -cp ./antlr-3.5.2-complete.jar -Xdiags:verbose myInterp_test.java myInterpParser.java myInterpLexer.java

test1:
	java -cp ./antlr-3.5.2-complete.jar:. myInterp_test example.c

test2:
	java -cp ./antlr-3.5.2-complete.jar:. myInterp_test example2.c

test3:
	java -cp ./antlr-3.5.2-complete.jar:. myInterp_test example3.c

clean:
	rm myInterpLexer.java myInterpParser.java *.tokens *.class
