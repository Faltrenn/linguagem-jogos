%{ 
#include <stdio.h>
#include <string.h>

#include "language.tab.h"

extern char *content;

%} 

%option nounput
%option noinput
  
%% 
"func"              { return TK_FUNC; }

"var"               { return TK_VAR; }

"const"             { return TK_CONST; }

"if"                { return TK_IF; }

"do"                { return TK_DO; }

"while"             { return TK_WHILE; }

"for"               { return TK_FOR; }

"in"                { return TK_IN; }

"..."               { return TK_FOR_INC_INC; }

"..<"               { return TK_FOR_INC_EXC; }

">.."               { return TK_FOR_EXC_INC; }

">.<"               { return TK_FOR_EXC_EXC; }

"not"               { return TK_COP_NOT; }

"true"              { return TK_VAL_TRUE; }

"false"             { return TK_VAL_FALSE; }

"collide"             { return TK_LOP_INTER; }

"and"               { return TK_LOP_AND; }

"or"                { return TK_LOP_OR; }

"."                 { return TK_DOT; }

"("                 { return TK_OPEN_BRACKET; }

")"                 { return TK_CLOSE_BRACKET; }

"{"                 { return TK_OPEN_BRACE; }

"}"                 { return TK_CLOSE_BRACE; }

[0-9]+              { return TK_VAL_INT; }

[0-9]*\.[0-9]+      { return TK_VAL_FLOAT; }

[a-zA-Z][a-zA-Z0-9_]*      { return TK_NAME; }

\"[ -~]*\"          { return TK_VAL_STRING; }
 
\n                  {  }

[ \t]               {  }

"->"                { return TK_RETURN_TYPE; }

","                 { return TK_COMMA; }

"="                 { return TK_EQUALS; }

">"                 { return TK_COP_BIGGER; }

"<"                 { return TK_COP_SMALLER; }

"+"                 { return TK_ADD; }

"-"                 { return TK_SUB; }

"/"                 { return TK_DIV; }

"*"                 { return TK_MUL; }

.                   { printf("unknown character %c\n", *yytext); }
%% 
  
int yywrap(void)
{
    if (content != NULL) {
        FILE *f = fopen("code.c", "w");
        fprintf(f, "%s", content);
    }

    return 1;
} 