%{ 
#include <stdio.h>
#include <string.h>

#include "language.tab.h"
%} 

%option nounput
%option noinput
  
%% 
"func"              { return TK_FUNC; }

"var"               { return TK_VAR; }

"const"             { return TK_CONST; }

"if"                { return TK_IF; }

"("                 { return TK_OPEN_BRACKET; }

")"                 { return TK_CLOSE_BRACKET; }

"{"                 { return TK_OPEN_BRACE; }

"}"                 { return TK_CLOSE_BRACE; }

[0-9]+              { return TK_VAL_INT; }

[0-9]*\.[0-9]+       { return TK_VAL_FLOAT; }

[a-z][a-z0-9]*      { return TK_NAME; }

\"[ -~]*\"          { return TK_VAL_STRING; }
 
\n                  {  }

[ \t]               {  }

"->"                { return TK_RETURN_TYPE; }

","                 { return TK_COMMA; }

"="                 { return TK_EQUALS; }

.                   { printf("unknown character %c\n", *yytext); }
%% 
  
int yywrap(void)
{
    return 1;
} 