%{
#include "urlscanner.h"
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
bool url;
%}
URL href=\"[^\"]*\"
BETWEEN \>[^\<]*\<
%%
\n			{ if(yylineno == 1){ yylineno = 3; }else{ yylineno++; } }
{URL}			{ url = true; cutURL(yytext); return TOKEN_URL; }
{BETWEEN}		{ if(url == true){ url = false; cutText(yytext); return TOKEN_TEXT; } if(strchr(yytext, '\n') != NULL){yylineno++;} }
<<EOF>>			{ return -1; }
.			{ }
%%
int yywrap()	{return 1; }
void cutText(char* string){
	int length = strlen(string)-2;
	char* tmp = string;
	tmp++;
	tmp[length] = '\0';
	yylval = tmp;	
}
void cutURL(char* string){
	int length = strlen(string)-7;
	char* tmp = string;
	tmp += 6;
	tmp[length] = '\0';
	yylval = tmp;
}
