.source noSource
.class public static result
.super java/lang/Object
.method public static main([Ljava/lang/String;)V

.limit stack 100
.limit locals 100

	ldc 13
	istore 0
	ldc 46
	istore 1
	iload 0
	iload 1
	iadd
	istore 2
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc ""
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc "Hello!"
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc "k = 59"
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	ldc 0

return
.end method
