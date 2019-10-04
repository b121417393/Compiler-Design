這次作業的compiler程式使用ANTLR3.5.2來編寫
撰寫的語言為JAVA，寫出的程式能夠編譯C程式語言的subset(相關定義在myInterp.g中，相關說明在description中)成為jasmion code的格式

使用前先使用make指令產生myCompiler_test.class檔及其它附屬檔案
(詳細呼叫指令請詳見makefile檔的內容)

之後使用make test1、make test2、make test3指令即可對三個範例程式分別進行測試
(詳細呼叫指令請詳見makefile檔的內容)

若要清除原先檔案以外的衍生檔案可使用make clean指令
(使用make clean會呼叫rm myCompilerLexer.java myCompilerParser.java *.tokens *.class 將額外製造出的檔案移除)


在進行測試時因為myCompiler.g中的撰寫方式，編譯的程式中必須要有printf function時才會看的到輸出結果
在此C的subset中並無支援變數在宣告時就能賦值的功能
此C的subset可支援整數、浮點數及常數的算術運算運算，以及相對應的比較運算

本程式的執行環境為ubuntu 18.04 ， 使用ALTLR來輔助編寫程式
myCompiler.g中的內容即為自行定義的C語言的Subset，老師所提出的要求功能全部都有實作
myCompiler_test.java中的內容為呼叫由myCompiler.g所編譯出的myCompilerParser.java及myCompilerScanner.java等內容

405235035 資工三 王博輝 b121417393@gmail.com
