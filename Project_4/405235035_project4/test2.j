.source noSource
.class public static result
.super java/lang/Object
.method public static main([Ljava/lang/String;)V

.limit stack 100
.limit locals 100

	ldc 12.0
	fstore 0
	ldc 45.0
	fstore 1
	fload 0
	fload 1
	fadd
	fstore 2
	fload 2
	ldc 0.0
	fcmpl
	ifle L1
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc ""
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc "Hello!"
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc "This is then part!"
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	goto L2
L1:
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc ""
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc "This is else part!"
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc "k = 57.0"
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
L2:
	ldc 0

return
.end method
