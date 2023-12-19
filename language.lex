%{ 
#include <stdio.h>
#include <string.h>

#include "language.tab.h"
%} 

%option nounput
%option noinput
  
%% 

"var"               { return TK_VAR; }

"const"             { return TK_CONST; }

"func"              { return TK_FUNC; }

"("                 { return TK_OPEN_BRACKET; }

")"                 { return TK_CLOSE_BRACKET; }

"{"                 { return TK_OPEN_BRACE; }

"}"                 { return TK_CLOSE_BRACE; }

[0-9]+              { return TK_NUM_INT; }

[0-9]*.[0-9]+       { return TK_NUM_FLOAT; }

[a-z][a-z0-9]*      { return TK_NAME; }

\"[ -~]*\"          { return TK_STRING; }
 
\n                  {  }

[ \t]               {  }

"->"                { return TK_RETURN_TYPE; }

","                 { return TK_COMMA; }

"="                 { return TK_EQUALS; }

.                   { printf("unknown character %c\n", *yytext); }
%% 
  
int yywrap(void)
{
    return 0;
} 