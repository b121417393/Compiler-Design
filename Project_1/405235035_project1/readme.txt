這次作業的scanner程式使用ANTLR3.5.2來編寫
撰寫lexer的語言為JAVA，編譯出的程式能夠切割C程式語言的subset(自行定義在mylexer.g中)

使用前先使用make指令產生testLexer.class檔及其它附屬檔案
(使用make會呼叫java -cp antlr-3.5.2-complete.jar org.antlr.Tool mylexer.g及javac -cp ./antlr-3.5.2-complete.jar testLexer.java mylexer.java兩道指令)

之後使用make test1、make test2、make test3指令即可對三個範例程式分別進行scanner
(使用make test?會呼叫java -cp ./antlr-3.5.2-complete.jar:. testLexer ???.c指令來進行測試)

若要清除除了原先檔案以外的東西可使用make clean指令
(使用make clean會呼叫rm mylexer.java mylexer.tokens *.class將額外製造出的檔案移除)

本程式的執行環境為ubuntu 18.04 ， 使用ALTLR來輔助編寫程式
mylexer.g中的內容即為自行定義的C語言的Subset
testLexer.java中的內容為呼叫由mylexer.g所編譯出的mylexer.class的內容
內容為將input中的資料根據mylexer.g中的定義進行切割並印出token編號和內容
在這邊我將空白及換行省略，以便觀察輸出結果

405235035 資工三 王博輝 b121417393@gmail.com
