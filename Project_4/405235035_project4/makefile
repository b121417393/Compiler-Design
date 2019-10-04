all: myCompiler_test.class

myCompiler_test.class:
	java -cp antlr-3.5.2-complete.jar org.antlr.Tool myCompiler.g
	javac -cp ./antlr-3.5.2-complete.jar -Xdiags:verbose myCompiler_test.java myCompilerParser.java myCompilerLexer.java

test1:
	rm test1.j
	java -cp ./antlr-3.5.2-complete.jar:. myCompiler_test test1.c >> test1.j
	java -jar jasmin.jar test1.j
	java result

test2:
	rm test2.j
	java -cp ./antlr-3.5.2-complete.jar:. myCompiler_test test2.c >> test2.j
	java -jar jasmin.jar test2.j
	java result

test3:
	rm test3.j
	java -cp ./antlr-3.5.2-complete.jar:. myCompiler_test test3.c >> test3.j
	java -jar jasmin.jar test3.j
	java result

clean:
	rm myCompilerLexer.java myCompilerParser.java *.tokens *.class
