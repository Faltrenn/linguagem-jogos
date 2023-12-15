%{ 
#include <stdio.h>
#include <string.h>

#include "language.tab.h"
%} 

%option nounput
%option noinput
  
%% 

"if"                { return TK_IF; }

"else if"           { return TK_ELSE_IF; }

"else"              { return TK_ELSE; }

"class"             { return TK_CLASS; }

"extends"           { return TK_EXTENDS; }

"static"            { return TK_STATIC; }

"init"              { return TK_INIT; }

"self"              { return TK_SELF; }

"get"               { return TK_GET; }

"set"               { return TK_SET; }

"private"           { return TK_PRIVATE; }

"func"              { return TK_FUNC; }

"->"                { return TK_SETA_RETURN; }

"int"               { return TK_INT; }

"float"             { return TK_FLOAT; }

"double"            { return TK_DOUBLE; }

"str"               { return TK_STR; }

"scalar"            { return TK_SCALAR; }

"circle"            { return TK_CIRCLE; }

"rectangle"         { return TK_RECTANGLE; }

"point"             { return TK_POINT; }

"bool"              { return TK_BOOL; }

"true"              { return TK_TRUE; }

"false"             { return TK_FALSE; }

"and"               { return TK_AND; }

"or"                { return TK_OR; }

"not"               { return TK_NOT; }

"do"                { return TK_DO; }

"while"             { return TK_WHILE; }

"for"               { return TK_FOR; }

"in"                { return TK_IN; }

"..."               { return TK_INC_INC; }

"..<"               { return TK_INC_EXC; }

">."                { return TK_EXC_INC; }

">.<"               { return TK_EXC_EXC; }

"break"             { return TK_BREAK; }

"return"            { return TK_RETURN; }

"include"           { return TK_INCLUDE; }

"from"              { return TK_FROM; }

"as"                { return TK_AS; }

"null"              { return TK_NULL; }

"rename"            { return TK_TYPEDEF; }

"to"                { return TK_TO; }

"match"             { return TK_MATCH; }

"case"              { return TK_CASE; }

"default"           { return TK_DEFAULT; }

"enum"              { return TK_ENUM; }

"main"              { return TK_MAIN; }

"void"              { return TK_VOID; }

"let"               { return TK_LET; }

"var"               { return TK_VAR; }

"+"                 { return TK_OP_ADD; }

"-"                 { return TK_OP_SUB; }

"*"                 { return TK_OP_MUL; }

"/"                 { return TK_OP_DIV; }

"="                 { return TK_IGUAL; }

"{"                 { return TK_ABR_CHA; }

"}"                 { return TK_FEC_CHA; }

"("                 { return TK_ABR_PAR; }

")"                 { return TK_FEC_PAR; }

"["                 { return TK_ABR_COL; }

"]"                 { return TK_FEC_COL; }

","                 { return TK_VIR; }

";"                 { return TK_PON_VIR; }

":"                 { return TK_DOI_PON; }

"."                 { return TK_PON; }

"?"                 { return TK_INTER; }

"_"                 { return TK_UNDER; }

[0-9]+              { return TK_NUM_INT; }

[0-9]*.[0-9]+       { return TK_NUM_FLOAT; }

[a-z]([a-z0-9])*    { return TK_NAME; }

\n                  { return TK_EOL; }

[ \t]               {  }

.                   { printf("unknown character %c\n", *yytext); }
%% 
  
int yywrap(void)
{
    return 0;
} 