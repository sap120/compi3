
%{
#include <stdio.h>
#include "part2_helpers.h"
#include "source.tab.h"
//void show_token(char* name);
//void show_str();
void print_error();

%}

/*definition section*/

%option yylineno
%option noyywrap

digit	([0-9])
letter	([a-zA-Z])
num 	({digit}+)
id	({letter})({digit}|{letter}|_)*
int8 (int8)
int16 (int16)
int32 (int32)
void (void)
write (write)
read (read)
while (while)
do (do)
if (if)
then (then)
else (else)
return (return)
signs 	([(){},:;])
str 	(\"(\\.|[^\\"\n])*\")
relop 	(==|<>|<|<=|>|>=)
addop 	([+|-])
mulop 	([*|/])
assign (=)
and (&&)
or (\|\|)
not (!)
new_line (\n|\r\n)
comment_dos	(#[^\r\n]*\r\n)
comment_unix	(#[^\n]*\n)
whitespace	([\t ])

%%
{int8}		{yylval = makeNode(yytext, NULL, NULL); return int8;};
{int16}		{yylval = makeNode(yytext, NULL, NULL); return int16;};
{int32}		{yylval = makeNode(yytext, NULL, NULL); return int32;};
{void}		{yylval = makeNode(yytext, NULL, NULL); return T_VOID;};
{write}		{yylval = makeNode(yytext, NULL, NULL); return T_WRITE;};
{read}		{yylval = makeNode(yytext, NULL, NULL); return T_READ;};
{while}		{yylval = makeNode(yytext, NULL, NULL); return T_WHILE;};
{do}		{yylval = makeNode(yytext, NULL, NULL); return T_DO;};
{if}		{yylval = makeNode(yytext, NULL, NULL); return T_IF;};
{then}		{yylval = makeNode(yytext, NULL, NULL); return then;};
{else}		{yylval = makeNode(yytext, NULL, NULL); return T_ELSE;};
{return}	{yylval = makeNode(yytext, NULL, NULL); return T_RETURN;};
{num}		{yylval = makeNode("num", yytext, NULL); return NUM;};
{str}		{yytext[yyleng-1]=0; yylval = makeNode("str", ++yytext ,NULL); return STR;};
{assign}	{yylval = makeNode("assign", yytext, NULL); return ASSIGN;};
{relop}		{yylval = makeNode("relop", yytext, NULL); return RELOP;};
{addop}		{yylval = makeNode("addop", yytext, NULL); return ADDOP;};
{mulop}		{yylval = makeNode("mulop", yytext, NULL); return MULOP;};
{id} 		{yylval = makeNode("id", yytext, NULL); return ID;};
{and}		{yylval = makeNode("and", yytext, NULL); return AND;};
{or}		{yylval = makeNode("or", yytext, NULL); return OR;};
{not}		{yylval = makeNode("not", yytext, NULL); return NOT;};
{new_line}	;
{signs}		{yylval = makeNode(yytext, NULL, NULL); return yytext[0];};
{whitespace}	;
{comment_dos}	;
{comment_unix}	;
.		;

%%

void print_error(){
printf ("Lexical error: '%s' in line number %d\n", yytext, yylineno);
	exit (1);
}
