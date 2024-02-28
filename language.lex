%{ 
#include <stdio.h>
#include <string.h>

#include "language.tab.h"

extern FILE *file;

%} 

%option nounput
%option noinput
  
%%

"func"                              {   return TK_FUNC;             }

"return"                            {   return TK_RTRN;             }

"var"                               {   return TK_VAR;              }

"->"                                {   return TK_FUNC_RTRN;        }

"="                                 {   return TK_EQUALS;           }

\+                                  {   return TK_MOP_PLUS;         }

\-                                  {   return TK_MOP_MINUS;        }

[a-zA-Z][a-zA-Z0-9_\-]*             {   return TK_NAME;             }

[0-9][0-9]*                         {   return TK_VAL_INT;          }

[0-9]*\.[0-9]+                      {   return TK_VAL_FLOAT;        }

\(                                  {   return TK_OPN_BRACK;        }

\)                                  {   return TK_CLS_BRACK;        }

\{                                  {   return TK_OPN_BRACE;        }

\}                                  {   return TK_CLS_BRACE;        }

\"[ -~]*\"                          {   return TK_VAL_STRING;       }

\.                                  {   return TK_DOT;              }

\,                                  {   return TK_COMMA;            }

\n                                  {   return TK_EOL;              }

[ \t]                               {                               }

\/\/[ -~]*\n                        {                               }

\/\*[ -~\n]*\*\/                    {                               }

.                                   {   
                                        printf("unknown character %c\n", *yytext);
                                        return 0;
                                    }
%% 
  
int yywrap(void) {  return 1;   }