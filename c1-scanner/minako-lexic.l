%{
#include "minako.h"
#include <stdio.h>
#include <string.h>
#define yystype char*
%}
DIGIT [0-9]
INTEGER {DIGIT}+
FLOAT {INTEGER}"."{INTEGER}|"."{INTEGER}
LETTER [a-zA-Z]
TEST "/*"
CCOMMENT "/*"[^"*/"]*"*/"
CPPCOMMENT "//"[^"\n"]*"\n"
%%
\n			{ if(yylineno == 1){ yylineno = 3; }else{ yylineno++; } }
{CCOMMENT}		/* ignoriere Kommentare	*/
{CPPCOMMENT}		/* ignoriere Kommentare */
(" "|\t|\n)		/* ignoriere Leerzeichen */
bool			{return KW_BOOLEAN; }
do			{return KW_DO; }
else			{return KW_ELSE; }
float			{return KW_FLOAT; }
for			{return KW_FOR; }
if			{return KW_IF; }
int			{return KW_INT; }
printf			{return KW_PRINTF; }
return			{return KW_RETURN; }
void			{return KW_VOID; }
while			{return KW_WHILE; }
"+"			{ return 43; }
"-"			{ return 45; }
"*"			{ return 42; }
"/"			{ return 47; }
"="			{ return 61; } 
"=="			{ return EQ; }
"!="			{ return NEQ; }
"<"			{ return LSS; }
">"			{ return GRT; }
"<="			{ return LEQ; }
">="			{ return GEQ; }
"&&"			{ return AND; }
"||"			{ return OR; }
","			{ return 44; }
";"			{ return 59; }
"("			{ return 40; }
")"			{ return 41; }
"{"			{ return 123; }
"}"			{ return 125; }
{INTEGER}		{ yylval.intValue = atoi(yytext); return CONST_INT; }
"true"|"false"		{ yylval.intValue = strcmp("false", yytext); return CONST_BOOLEAN; }
"\""[^\n\"]*"\""	{ yylval.string = yytext; return CONST_STRING; }
({LETTER})+({DIGIT}|{LETTER})* { yylval.string = yytext; return ID; }
{FLOAT}([eE]([-+])?{INTEGER})?|{INTEGER}[eE]([-+])?{INTEGER}	{ yylval.floatValue = atof(yytext); return CONST_FLOAT; }
<<EOF>>			{ return -1; }
.			{ printf("Unerwartetes Zeichen in Zeile %d: %s\n", yylineno, yytext); return -1; }
%%
int yywrap()	{return 1; }

