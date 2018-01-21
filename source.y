%{
#include <stdio.h>
//#include <map>
//#include <string>
#include "part2_helpers.h"
//#include "part2_helpers.c"
//using namespace std;

int yylex();
void yyerror(const char*);
extern char* yytext;
extern int yylineno;

PparserNode parseTree;//pointer to the root of the parsing tree



 %}

//the tokens of the language organized by priority and association
%token T_READ "read";
%token T_WRITE "write"; 
%token T_WHILE "while";
%token T_DO "do";
%token int8;
%token int16;
%token int32;
%token T_VOID "void";
%token T_RETURN "return";
%token RESERVED;
%token T_IF "if";
%token NUM;
%token ID;
%token STR;
%left ASSIGN;
%left OR;
%left AND;
%left RELOP;
%left ADDOP;
%left MULOP;
%right NOT;
%left '('
%left ')' 
%left '[' 
%left ']' 
%left '{' 
%left '}'
%left ':'
%left ';'
%right then;
%right T_ELSE "else";


%%

/*rules of the language*/

PROGRAM : FDEFS			{$$ = makeNode("PROGRAM", NULL, $1); parseTree = $$;}
;
FDEFS : 
FDEFS FUNC_API BLK		{$$ = makeNode("FDEFS", NULL, concatList(concatList($1, $2), $3));}
| FDEFS FUNC_API ';'		{$$ = makeNode("FDEFS", NULL, concatList(concatList($1, $2), $3));}  
| /*epsilon*/			{$$ = makeNode("FDEFS", NULL, makeNode("EPSILON", NULL, NULL));};
;
FUNC_API : 
TYPE ID '(' FUNC_ARGS ')'	{$$ = makeNode("FUNC_API", NULL, concatList($1, $2)); concatList($1,$3), concatList($1, $4), concatList($1, $5);}
;
FUNC_ARGS : 
FUNC_ARGLIST			{$$ = makeNode("FUNC_ARGS", NULL, $1);}
| /*epsilon*/			{$$ = makeNode("FUNC_ARGS", NULL, makeNode("EPSILON", NULL, NULL));};
;
FUNC_ARGLIST : 
FUNC_ARGLIST ',' DCL		{$$ = makeNode("FUNC_ARGLIST", NULL, concatList(concatList($1, $2), $3));}		
| DCL				{$$ = makeNode("FUNC_ARGLIST", NULL, $1);}
;
BLK : 
'{' STLIST '}'			{$$ = makeNode("BLK", NULL, concatList(concatList($1, $2), $3));}
;
DCL : 
ID ':' TYPE			{$$ = makeNode("DCL", NULL, concatList(concatList($1, $2), $3));}			 
| ID ',' DCL			{$$ = makeNode("DCL", NULL, concatList(concatList($1, $2), $3));}
;
TYPE :
int8				{$$ = makeNode("TYPE", NULL, $1);} 
| int16				{$$ = makeNode("TYPE", NULL, $1);} 
| int32				{$$ = makeNode("TYPE", NULL, $1);} 	
| T_VOID				{$$ = makeNode("TYPE", NULL, $1);}
;
STLIST : 
STLIST STMT			{$$ = makeNode("STLIST", NULL, concatList($1, $2));} 
| /*epsilon*/			{$$ = makeNode("STLIST", NULL, makeNode("EPSILON", NULL, NULL));};
;
STMT : 
DCL ';'				{$$ = makeNode("STMT", NULL, concatList($1, $2));} 
| ASSN				{$$ = makeNode("STMT", NULL, $1);} 
| EXP ';'			{$$ = makeNode("STMT", NULL, concatList($1, $2));} 
| CNTRL				{$$ = makeNode("STMT", NULL, $1);} 
| READ				{$$ = makeNode("STMT", NULL, $1);} 
| WRITE				{$$ = makeNode("STMT", NULL, $1);} 
| RETURN			{$$ = makeNode("STMT", NULL, $1);} 
| BLK				{$$ = makeNode("STMT", NULL, $1);}
;
RETURN : 
T_RETURN EXP ';' 			{$$ = makeNode("RETURN", NULL, concatList($1, concatList($2, $3)));}
| T_RETURN ';' 			{$$ = makeNode("RETURN", NULL, concatList($1, $2));}
;
WRITE : 
T_WRITE '(' EXP ')' ';'		{$$ = makeNode("WRITE", NULL, concatList($1, $2)); concatList($1,$3), concatList($1, $4), concatList($1, $5);}
| T_WRITE '(' STR ')' ';' 	{$$ = makeNode("WRITE", NULL, concatList($1, $2)); concatList($1,$3), concatList($1, $4), concatList($1, $5);}
;
READ :
T_READ '(' LVAL ')' ';'		{$$ = makeNode("READ", NULL, concatList($1, $2)); concatList($1,$3), concatList($1, $4), concatList($1, $5);}
;
ASSN :
LVAL ASSIGN EXP ';'		{$$ = makeNode("ASSN", NULL, concatList($1, $2)); concatList($1,$3), concatList($1, $4);}
;
LVAL :
ID				{$$ = makeNode("LVAL", NULL, $1);}
;
CNTRL :
T_IF BEXP then M STMT N T_ELSE M STMT	{$$ = makeNode("CNTRL", NULL, concatList($1, $2)); concatList($1,$3), concatList($1, $4), concatList($1, $5), concatList($1, $6);}
| T_IF BEXP then M STMT 		{$$ = makeNode("CNTRL", NULL, concatList($1, $2)); concatList($1,$3), concatList($1, $4);}
| T_WHILE BEXP T_DO M STMT	{$$ = makeNode("CNTRL", NULL, concatList($1, $2)); concatList($1,$3), concatList($1, $4);}
;
BEXP :
BEXP OR M BEXP			{$$ = makeNode("BEXP", NULL, concatList($1, $2)); concatList($1,$3);}
| BEXP AND M BEXP			{$$ = makeNode("BEXP", NULL, concatList($1, $2)); concatList($1,$3);}
| NOT BEXP			{$$ = makeNode("BEXP", NULL, concatList($1, $2));}
|EXP RELOP EXP			{$$ = makeNode("BEXP", NULL, concatList($1, $2)); concatList($1,$3);}
| '(' BEXP ')'			{$$ = makeNode("BEXP", NULL, concatList($1, $2)); concatList($1,$3);}
;
EXP :
EXP ADDOP EXP 			{$$ = makeNode("EXP", NULL, concatList($1, $2)); concatList($1,$3);}
| EXP MULOP EXP			{$$ = makeNode("EXP", NULL, concatList($1, $2)); concatList($1,$3);}
| '(' EXP ')'			{$$ = makeNode("EXP", NULL, concatList($1, $2)); concatList($1,$3);}
| '(' TYPE ')' EXP 	 	{$$ = makeNode("EXP", NULL, concatList($1, $2)); concatList($1,$3), concatList($1, $4);}
| ID				{$$ = makeNode("EXP", NULL, $1);}
| NUM				{$$ = makeNode("EXP", NULL, $1);}
| CALL				{$$ = makeNode("EXP", NULL, $1);}
;
CALL :
ID '(' CALL_ARGS ')'		{$$ = makeNode("CALL", NULL, concatList($1, $2)); concatList($1,$3), concatList($1, $4);}
;
CALL_ARGS : CALL_ARGLIST	{$$ = makeNode("CALL_ARGS", NULL, $1);}
| /*epsilon*/			{$$ = makeNode("CALL_ARGS", NULL, makeNode("EPSILON", NULL, NULL));};
;
CALL_ARGLIST :
CALL_ARGLIST ',' EXP		{$$ = makeNode("CALL_ARGLIST", NULL, concatList(concatList($1, $2), $3));}
| EXP				{$$ = makeNode("CALL_ARGLIST", NULL, $1);}
;


%%
//error handling function
void yyerror(const char* token){
	printf ("Syntax error: '%s' in line number %d\n", yytext, yylineno);
	exit (2);
}			
