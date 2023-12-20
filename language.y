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
%token TK_LOP_BIGGER TK_LOP_SMALLER TK_LOP_NOT TK_VAL_TRUE TK_VAL_FALSE
%token TK_VAL_FLOAT TK_VAL_INT TK_VAL_STRING
%token TK_NAME
%token TK_COMMA TK_WS
%token TK_IF

%%
program:
    | func_create program
;


conditional:
    TK_IF condition block
                                {
                                    free($$);
                                    $$ = malloc((5 + strlen($2) + strlen($3)) * sizeof(char));
                                    strcpy($$, "if(");
                                    strcat($$, $2);
                                    strcat($$, ")");
                                    strcat($$, $3);
                                }


condition:
    value                 { $$ = strdup($1); }
    | TK_OPEN_BRACKET value TK_CLOSE_BRACKET { $$ = $2; }
;


func_create_param:
                            { $$ = ""; }
    | name name             {
                                $1 = strdup($1);
                                free($$);
                                $$ = malloc((2 + strlen($1) + strlen($2)) * sizeof(char));
                                strcpy($$, $1);
                                strcat($$, " ");
                                strcat($$, $2);
                            }
    | name name TK_COMMA func_create_param
                            {
                                $1 = strdup($1);
                                free($$);
                                $$ = malloc((3 + strlen($1) + strlen($2) + strlen($4)) * sizeof(char));
                                strcpy($$, $1);
                                strcat($$, " ");
                                strcat($$, $2);
                                strcat($$, ",");
                                strcat($$, $4);
                            }

;


func_create:
    TK_FUNC name TK_OPEN_BRACKET func_create_param TK_CLOSE_BRACKET func_create_return block
                                     {
                                         printf("%s %s (%s)%s\n", $6, $2, $4, $7);
                                     }
;


func_create_return:
                                    { $$ = "void"; }
    | TK_RETURN_TYPE name           { $$ = strdup($2); }
;


commands:
    command                     { $$ = strdup($1); }
    | command commands          {
                                    $1 = strdup($1);
                                    free($$);
                                    $$ = malloc((1 + strlen($1) + strlen($2)) * sizeof(char));
                                    strcpy($$, $1);
                                    strcat($$, $2);
                                }
;


command:
                                { $$ = ""; }
    | func_exec                 {
                                    char *aux = strdup($$);
                                    free($$);
                                    $$ = malloc((2 + strlen(aux)) * sizeof(char));
                                    strcpy($$, aux);
                                    strcat($$, ";");
                                    free(aux);
                                }
    | define_var
    | conditional
;


func_exec_param:
                                    { $$ = ""; }
    | value                         { $$ = strdup($1); }
    | value TK_COMMA func_exec_param     {
                                        $1 = strdup($1);
                                        free($$);
                                        $$ = malloc((2 + strlen($1) + strlen($3)) * sizeof(char));
                                        strcpy($$, $1);
                                        strcat($$, ",");
                                        strcat($$, $3);
                                    }
;

func_exec:
    name TK_OPEN_BRACKET func_exec_param TK_CLOSE_BRACKET
                                {
                                    $1 = strdup($1);
                                    free($$);
                                    $$ = malloc((4 + strlen($1) + strlen($3)) * sizeof(char));
                                    strcpy($$, $1);
                                    strcat($$, "(");
                                    strcat($$, $3);
                                    strcat($$, ")");
                                }
;


 define_var:
    TK_VAR name name assign     {
                                    free($$);
                                    $$ = malloc((6 + strlen($2) + strlen($3) + strlen($4)) * sizeof(char));
                                    strcpy($$, $2);
                                    strcat($$, " ");
                                    strcat($$, $3);
                                    strcat($$, $4);
                                    strcat($$, ";");
                                }
;


assign:
                                {   $$ = strdup("");    }
    | TK_EQUALS value           {
                                    free($$);
                                    $$ = malloc((2 + strlen($2)) * sizeof(char));
                                    strcpy($$, "=");
                                    strcat($$, $2);
                                }


block:
    TK_OPEN_BRACE commands TK_CLOSE_BRACE {
                                            free($$);
                                            $$ = malloc((3 + strlen($2)) * sizeof(char));
                                            strcpy($$, "{");
                                            strcat($$, $2);
                                            strcat($$, "}");
                                        }
;


logic_op:
    TK_LOP_BIGGER                   { $$ = ">"; }
    | TK_LOP_SMALLER                { $$ = "<"; }
    | TK_EQUALS TK_EQUALS           { $$ = "=="; }
    | TK_LOP_BIGGER TK_EQUALS       { $$ = ">="; }
    | TK_LOP_SMALLER TK_EQUALS      { $$ = "<="; }


value_bool:
    TK_VAL_TRUE                     { $$ = "1"; }
    | TK_VAL_FALSE                  { $$ = "0"; }
    | value
    | name logic_op value_bool      {
                                        $1 = strdup($1);
                                        free($$);
                                        $$ = malloc((1+ strlen($1) + strlen($2) + strlen($3)) * sizeof(char));
                                        strcpy($$, $1);
                                        strcat($$, $2);
                                        strcat($$, $3);
                                    }
;


value:
    func_exec
    | TK_VAL_INT                    { $$ = strdup(yytext); }
    | TK_VAL_STRING                 { $$ = strdup(yytext); }
    | TK_VAL_FLOAT                  { $$ = strdup(yytext); }
    | name
    | value_bool
;


name:
    TK_NAME                         { $$ = strdup(yytext); }
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