# parser
Parser using lex and yacc tool and C++ language
parse.l is lex file with tokens and operators defined in it.
parse.y is yacc file with definitions,grammars,c++ code to be appended sections.
inputomega is input file

Commands to run the project
bison -d parse.y
flex parse.l
g++ parse.tab.c lex.yy.c -lfl -o omega
./omega
