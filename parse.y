/*
% bison -d omega.y
% flex omega.l
% g++ omega.tab.c lex.yy.c -lfl -o omega
% ./omega
*/

%{
#include <bits/stdc++.h>
using namespace std;
extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;
extern int line_num;
void yyerror(const char *s);
%}

/*----------------------------------------------Definition Section----------------------------------------------*/

%union 
{
	int ival;
	float fval;
	char *sval;
	char *idval;
	
}

%token SNAZZLE
%token END ENDL
%token INT 
%token FLOAT 
%token ALPHA
%token TR
%token REPEAT
%token TEST 
%token OR
%token SHOW
%token FUNC
%token VOID

%left GE GT LE LT EQQ NE OP CP OB CB COM
%left ADD SUB MUL DIV
%right EQ 

%token <ival> NUM
%token <fval> DEC
%token <sval> STRING
%token <idval>	ID;


%%

//----------------------------------Grammar Rules Section---------------------------------------------------

Omega:
	header stmt_block footer { cout << "\n\n\n"<<"------Congratulations!!!------Parsing done!--------" <<"\n\n"<< endl; }
	;
header:
	SNAZZLE ENDLS{ cout << "-------Reading an Omega program-------- " <<"\n\n\n"<< endl; }
	;
stmt_block:
	stmts
	;
stmts:
	stmt stmts
	| stmt
	;
stmt:
	declare_stmt 
	| declare_stmt_assign_stmt
	|	assign_stmt
	|	if_stmt_or
	|	if_stmt
	|	for_stmt
	|	show_stmt
	|	func_call
	|	Expr
	;
declare_stmt:
	INT ID TR ENDLS{ cout << "--new int variable declared:--		INT "<< $2 <<" $ "<< endl; }
	|	FLOAT ID TR ENDLS{ cout << "--new float variable declared:-- 	FLOAT " << $2<<" $ " << endl; }
	|	ALPHA ID TR ENDLS{ cout << "--new alpha variable declared:-- ALPHA " << $2 <<" $ "<< endl; }
	|	TYPE FUNC ID OP func_arg CP TR ENDLS {	cout<<"--new function" <<$3<<" declared----"<< endl;} 
 	;
declare_stmt_assign_stmt:
		INT ID EQ NUM TR ENDLS { cout << "--new int variable declared and assigned:-- INT " << $2 <<" = "<< $4<<" $ "<< endl; }
	|	FLOAT ID EQ DEC TR ENDLS{ cout << "--new float variable declared and assigned:-- FLOAT " << $2 <<" = "<< $4<<" $ "<< endl; }
	|	ALPHA ID EQ STRING TR ENDLS{ cout << "--new alpha variable declared and assigned:-- ALPHA " << $2 <<" = "<< $4<<" $ "<< endl; }
	;
assign_stmt:
	ID EQ NUM TR ENDLS { cout << "--variable assigned:-- " << $1 <<" = "<< $3<<" $ "<< endl; }
	|	ID EQ DEC TR ENDLS{ cout << "--variable assigned:-- " << $1 <<"="<< $3<<" $"<< endl; }
	|	ID EQ STRING TR ENDLS{ cout << "--variable assigned:-- " << $1 <<"="<< $3<<" $"<< endl; }
	|	FUNC ID OP func_arg CP ENDLS OB ENDLS stmts ENDLS CB ENDLS 
	;
if_stmt_or:
	TEST OP log_exp CP ENDLS OB ENDLS stmts ENDLS CB ENDLS OR ENDLS OB ENDLS stmts ENDLS CB ENDLS {cout<<"--if statement with or declared--"<<endl;}
	;
if_stmt:	
	TEST OP log_exp CP ENDLS OB ENDLS stmts ENDLS CB ENDLS {cout<<"--test statement declared--"<<endl;}	
	;
for_stmt:
	REPEAT OP for_exp CP ENDLS OB ENDLS stmts	ENDLS CB ENDLS		{	cout<<"--repeat statement declared--"<<endl;} 
	;
for_exp:
	ID EQ NUM TR log_exp TR
	|	ID EQ STRING TR log_exp TR
	|	ID EQ FLOAT TR log_exp TR
	;
show_stmt:
	SHOW STRING TR ENDLS		{	cout<<" Show statement used "<<$2<<endl; }
	;  
func_arg:
	TYPE ID COM func_arg
	|	TYPE ID
	|
	;
func_call:
	FUNC ID OP func_call_arg CP TR ENDLS	{	cout<<"---function called ---"<<endl; }
	;
func_call_arg:
	NUM COM func_call_arg
	|	DEC COM func_call_arg
	|	STRING COM func_call_arg
	|	ID COM func_call_arg
	|	NUM
	|	DEC
	|	STRING
	|	ID
	;
log_exp:
	ID log_sym ID
	|	NUM log_sym NUM
	|	DEC log_sym DEC
	|	DEC log_sym NUM
	|	NUM log_sym DEC
	| ID log_sym DEC
	|	DEC log_sym ID
	|	NUM log_sym ID
	|	ID log_sym NUM
	;
Expr: ID EQ exp TR ENDLS
	;
exp: term ADD exp
	|	term SUB exp
	|	term
	;
term:	term MUL factor
	|	term DIV factor
	|	factor
	;
factor: NUM
	| FLOAT
	|	ID
	|	OP exp CP
	;
log_sym:	GE 
	|GT
	| LE 
	|LT
	| EQQ 
	|NE
	;
TYPE:	INT
	|	FLOAT
	|	ALPHA
	|	VOID
	;
footer:
	END ENDLS
	;
ENDLS:
	ENDL ENDLS
	| ENDL
	| 
	;

%%

/*-------------------------------------------Code copied to verbatim of the output----------------------------------------------*/

int main(int, char**) {
	// open a file handle to a particular file:
	FILE *myfile = fopen("inputomega", "r");
	// make sure it's valid:
	if (!myfile) {
		cout << "I can't open input.omega file!" << endl;
		return -1;
	}
	// set flex to read from it instead of defaulting to STDIN:
	yyin = myfile;

	// parse through the input until there is no more:
	do {
		yyparse();
	} while (!feof(yyin));
	
}

void yyerror(const char *s) {
	cout << "\n\n----Oops!!!!, parse error! on line "<<line_num<<" ! Message: " << s <<"--------"<< endl;
	// might as well halt now:
	exit(-1);
}
