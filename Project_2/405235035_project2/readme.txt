這次作業的parser程式使用ANTLR3.5.2來編寫
撰寫lexer的語言為JAVA，編譯出的程式能夠切割C程式語言的subset(自行定義在myparser.g中)

使用前先使用make指令產生testParser.class檔及其它附屬檔案
(使用make會呼叫java -cp antlr-3.5.2-complete.jar org.antlr.Tool myparser.g及javac -cp ./antlr-3.5.2-complete.jar testParser.java myparserParser.java myparserLexer.java兩道指令)

之後使用make test1、make test2、make test3指令即可對三個範例程式分別進行parser
(使用make test?會呼叫java -cp ./antlr-3.5.2-complete.jar:. testParser ?.c指令來進行測試)

測試時因為myparser.g中的撰寫方式，每次match到一個符合的statement時就會輸出一段文字
提醒測試者這時是根據哪一條敘述來match到程式碼，這邊我將空白、換行及註解忽略，故不會有輸出


若要清除除了原先檔案以外的東西可使用make clean指令
(使用make clean會呼叫rm myparserLexer.java myparserParser.jav *.tokens *.class 將額外製造出的檔案移除)

本程式的執行環境為ubuntu 18.04 ， 使用ALTLR來輔助編寫程式
myparser.g中的內容即為自行定義的C語言的Subset
testParser.java中的內容為呼叫由myparser.g所編譯出的myparserParser.class的內容

405235035 資工三 王博輝 b121417393@gmail.com
