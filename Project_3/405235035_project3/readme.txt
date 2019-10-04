這次作業的parser程式使用ANTLR3.5.2來編寫
撰寫的語言為JAVA，編譯出的程式能夠直譯C程式語言的subset(相關定義在myInterp.g中，相關說明在description中)

使用前先使用make指令產生myInterp_test.class檔及其它附屬檔案
(使用make會呼叫java -cp antlr-3.5.2-complete.jar org.antlr.Tool myInterp.g
 及javac -cp ./antlr-3.5.2-complete.jar -Xdiags:verbose myInterp_test.java myInterpParser.java myInterpLexer.java兩道指令)

之後使用make test1、make test2、make test3指令即可對三個範例程式分別進行parser
(使用make test?會呼叫java -cp ./antlr-3.5.2-complete.jar:. myInterp_test ?.c指令來進行測試)

若要清除除了原先檔案以外的東西可使用make clean指令
(使用make clean會呼叫rm myInterpLexer.java myInterpParser.java *.tokens *.class 將額外製造出的檔案移除)


在進行測試時因為myInterp.g中的撰寫方式，程式只有在匹配到printf function時才會有輸出
在此C的subset中並無支援直接輸入變數名稱或算式就能輸出結果的語法，必須要搭配printf function才行
但此C的subset可支援整數及浮點數的運算，浮點數和整數之間可以進行加減乘除...等一般運算


本程式的執行環境為ubuntu 18.04 ， 使用ALTLR來輔助編寫程式
myInterp.g中的內容即為自行定義的C語言的Subset
myInterp_test.java中的內容為呼叫由myInterp.g所編譯出的myInterpParser.java的內容

405235035 資工三 王博輝 b121417393@gmail.com
