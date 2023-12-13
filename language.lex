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

"func"              { return TK_FUNC; }

"int"               { return TK_INT; }

"float"             { return TK_FLOAT; }

"double"            { return TK_DOUBLE; }

"string"            { return TK_STRING; }

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

"while"             { return TK_WHILE; }

"for"               { return TK_FOR; }

"break"             { return TK_BREAK; }

"return"            { return TK_RETURN; }

"include"            { return TK_INCLUDE; }

"null"              { return TK_NULL; }

"+"                 { return TK_OP_ADD; }

"-"                 { return TK_OP_SUB; }

"*"                 { return TK_OP_MUL; }

"/"                 { return TK_OP_DIV; }

"{"                 { return TK_ABR_CHA; }

"}"                 { return TK_FEC_CHA; }

"("                 { return TK_ABR_PAR; }

")"                 { return TK_FEC_PAR; }

"["                 { return TK_ABR_COL; }

"]"                 { return TK_FEC_COL; }

","                 { return TK_VIR; }

";"                 { return TK_PON_VIR; }

"."                 { return TK_PON; }

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