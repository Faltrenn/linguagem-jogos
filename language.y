%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define YYSTYPE char *

extern char *yytext;
extern int yylex(void);
extern int yyerror(char* s);

unsigned int count = 0;
char buffer[256];
%}

%token TK_FUNC TK_OPEN_BRACKET TK_CLOSE_BRACKET TK_OPEN_BRACE TK_CLOSE_BRACE TK_RETURN_TYPE
%token TK_VAR TK_CONST
%token TK_EQUALS
%token TK_NUM_FLOAT TK_NUM_INT TK_STRING
%token TK_NAME
%token TK_COMMA TK_WS

%%
program:
 | function                     { return 0; }
 | program function             { return 0; }
 ;


function: TK_FUNC name TK_OPEN_BRACKET TK_CLOSE_BRACKET function_return block
                                {
                                    printf("%s %s (){%s}\n", $5, $2, $6);
                                }
 ;


block: TK_OPEN_BRACE command TK_CLOSE_BRACE { $$ = strdup($2); }
 ;


function_return: TK_RETURN_TYPE name { $$ = strdup(yytext); }
 |                                   { $$ = "void"; }
 ;


command: name TK_OPEN_BRACKET parameters TK_CLOSE_BRACKET
                                {
                                    $$ = $1;
                                    strcat($$, "(");
                                    strcat($$, strdup($3));
                                    strcat($$, ");");
                                }
 | define_var
 | command command
                                {
                                    $$ = $1;
                                    strcat($$, $2);
                                }
 |                              { $$ = ""; }
 ;


 define_var: TK_VAR name name  {
                                    $$ = $2;
                                    strcat($$, " ");
                                    strcat($$, $3);
                                    strcat($$, ";");
                               }
  | TK_VAR name name TK_EQUALS term
                               {
                                    $$ = $2;
                                    strcat($$, " ");
                                    strcat($$, $3);
                                    strcat($$, " = ");
                                    strcat($$, $5);
                                    strcat($$, ";");
                               }
 ;

name: TK_NAME                   { $$ = strdup(yytext); }
 ;


parameters: term                { $$ = $1; }
 | parameters TK_COMMA term     {
                                    $$ = $1;

                                    strcat($$, ", ");
                                    strcat($$, strdup(yytext));
                                }
 |                              { $$ = strdup(""); }
;


term: TK_NUM_INT                { $$ = strdup(yytext); }
 | TK_NUM_FLOAT                 { $$ = strdup(yytext); }
 | name                         { $$ = strdup(yytext); }
 ;
%%

int main(int argc, char **argv)
{
    extern FILE *yyin;

    yyin = fopen(argv[1], "r");
    yyparse();

    return 0;
}

int yyerror(char *s)
{
    fprintf(stderr, "error: %s\n", s);

    return 0;
}