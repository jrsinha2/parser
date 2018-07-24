%{
#include <iostream>
#include "parse.tab.h"
using namespace std;
#define YY_DECL extern "C" int yylex()
int line_num = 1;
%}

%%
[ \t] ;
Begin        { return SNAZZLE; }
End            { return END; }
int 					{	return INT;}
alpha {return ALPHA;}
float 		{	return FLOAT;}
test {return TEST;}
repeat {return REPEAT;	}
show {	return SHOW;}
or {return OR;}
func {	return FUNC;}
void {	return VOID;}


[0-9]+\.[0-9]+ { yylval.fval = atof(yytext); return DEC; }
[0-9]+         { yylval.ival = atoi(yytext); return NUM; }
['][a-z A-Z 0-9]+[']   { yylval.sval = strdup(yytext);	return STRING;}
[a-zA-Z0-9][a-zA-Z0-9]* { yylval.idval = strdup(yytext); return ID;}

">"	{	return GT;}
"<" {return LT;}
">=" {return GE;}
"<=" {return LE;}
"==" {return EQQ;}
"=" {return EQ;}
"!=" {   return NE;}
"$"		{	return TR;}
"("	{return OP;}
")"	{return CP;}
"$_"	{return OB;}
"_$"	{return CB;}
"+" {return ADD;}
"-" {return SUB;}
"*" {return MUL;}
"/" {return DIV;}
","	{return COM;}
\n		{	++line_num; return ENDL;}
. ;
%%
