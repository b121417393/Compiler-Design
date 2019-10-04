.source noSource
.class public static result
.super java/lang/Object
.method public static main([Ljava/lang/String;)V

.limit stack 100
.limit locals 100

	ldc 10.0
	fstore 0
	fload 0
	fload 0
	fadd
	fstore 2
	fload 2
	fload 2
	fmul
	fstore 2
	ldc 20.0
	fneg
	ldc 60.0
	fadd
	fstore 1
	fload 2
	fload 1
	fcmpl
	ifge L1
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc ""
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc "Oh yeah! k < j !"
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc "j = 40.0"
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc "k = 400.0"
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	goto L2
L1:
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc ""
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc "Oops! k > j !"
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc "j = 40.0"
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc "k = 400.0"
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
L2:
	ldc 0

return
.end method
