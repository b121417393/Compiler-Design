all: testLexer.class

testLexer.class:
	java -cp antlr-3.5.2-complete.jar org.antlr.Tool mylexer.g
	javac -cp ./antlr-3.5.2-complete.jar testLexer.java mylexer.java

test1:
	java -cp ./antlr-3.5.2-complete.jar:. testLexer helloworld.c

test2:
	java -cp ./antlr-3.5.2-complete.jar:. testLexer fibonacci.c

test3:
	java -cp ./antlr-3.5.2-complete.jar:. testLexer grade.c

clean:
	rm mylexer.java mylexer.tokens *.class
