%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define YYSTYPE char *

extern char *yytext;
extern int yylex(void);
extern int yyerror(char* s);
char *recover_value(char* s);

char *content = NULL;

%}

%token TK_FUNC TK_OPEN_BRACKET TK_CLOSE_BRACKET TK_OPEN_BRACE TK_CLOSE_BRACE TK_RETURN_TYPE
%token TK_VAR TK_CONST
%token TK_EQUALS
%token TK_LOP_BIGGER TK_LOP_SMALLER TK_LOP_NOT TK_VAL_TRUE TK_VAL_FALSE
%token TK_VAL_FLOAT TK_VAL_INT TK_VAL_STRING
%token TK_NAME
%token TK_COMMA TK_DOT
%token TK_IF
%token TK_WHILE TK_DO TK_FOR TK_IN TK_FOR_INC_INC TK_FOR_INC_EXC TK_FOR_EXC_INC TK_FOR_EXC_EXC

%%
program:
    | program func_create       {
                                    if(content != NULL) {
                                        char *aux = strdup(content);
                                        free(content);
                                        content = malloc((1 + strlen(aux) + strlen($2)) * sizeof(char));
                                        strcpy(content, aux);
                                        strcat(content, $2);
                                    } else {
                                        content = malloc((39 + strlen($2)) * sizeof(char));
                                        strcpy(content, "#include \"basic.h\"\n#include <stdio.h>\n");
                                        strcat(content, $2);
                                    }
                                }
;


conditional:
    TK_IF condition block       {
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


func_create:
    TK_FUNC name TK_OPEN_BRACKET func_create_param TK_CLOSE_BRACKET func_create_return block
                                     {
                                        free($$);
                                        $$ = malloc((5 + strlen($6) + strlen($2) + strlen($4) + strlen($7)) * sizeof(char));
                                        strcpy($$, $6);
                                        strcat($$, " ");
                                        strcat($$, $2);
                                        strcat($$, "(");
                                        strcat($$, $4);
                                        strcat($$, ")");
                                        strcat($$, $7);
                                     }
;


func_create_param:
                            { $$ = strdup(""); }
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


func_create_return:
                                    { $$ = strdup("void"); }
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
                                { $$ = strdup(""); }
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
    | loop_repet
;

loop_repet:
    TK_WHILE loop_cond_while block 
                                   {
                                        free($$);
                                        $$ = malloc((8 + strlen($2) + strlen($3)) * sizeof(char));
                                        strcpy($$, "while(");
                                        strcat($$, $2);
                                        strcat($$, ")");
                                        strcat($$, $3);
                                    }
    | TK_DO block TK_WHILE loop_cond_while 
                                    {
                                        free($$);
                                        $$ = malloc((11 + strlen($2) + strlen($4)) * sizeof(char));
                                        strcpy($$, "do");
                                        strcat($$, $2);
                                        strcat($$, "while(");
                                        strcat($$, $4);
                                        strcat($$, ");");
                                    }
    | TK_FOR loop_for_cond block 
                                    {
                                        free($$);
                                        $$ = malloc((6 + strlen($2) + strlen($3)) * sizeof(char));
                                        strcpy($$, "for(");
                                        strcat($$, $2);
                                        strcat($$, ")");
                                        strcat($$, $3);
                                    }
;

loop_cond_while:
    TK_OPEN_BRACKET value TK_CLOSE_BRACKET
                                    { $$ = strdup($2); }
    | value
;   

loop_for_cond:
    name TK_IN num TK_FOR_INC_INC num 
                                    {
                                        $1 = strdup($1);
                                        free($$);
                                        $$ = malloc((24 + (3 * strlen($1)) + strlen($3) + strlen($5)) * sizeof(char));
                                        strcpy($$, "Int ");
                                        strcat($$, $1);
                                        strcat($$, "=");
                                        strcat($$, $3);
                                        strcat($$, ";");
                                        strcat($$, $1);
                                        strcat($$, ".value<=");
                                        $5 = recover_value($5);
                                        strcat($$, $5);
                                        strcat($$, ";");
                                        strcat($$, $1);
                                        strcat($$, ".value++");

                                    }
    | name TK_IN num TK_FOR_INC_EXC num 
                                    {
                                        $1 = strdup($1);
                                        free($$);
                                        $$ = malloc((28 + (3 * strlen($1)) + strlen($3) + strlen($5)) * sizeof(char));
                                        strcpy($$, "Int ");
                                        strcat($$, $1);
                                        strcat($$, "=");
                                        strcat($$, $3);
                                        strcat($$, ";");
                                        strcat($$, $1);
                                        strcat($$, ".value<");
                                        $5 = recover_value($5);
                                        strcat($$, $5);
                                        strcat($$, ";");
                                        strcat($$, $1);
                                        strcat($$, ".value++");

                                    }
    | name TK_IN num TK_FOR_EXC_INC num 
                                    {
                                        $1 = strdup($1);
                                        free($$);
                                        $$ = malloc((54 + (3 * strlen($1)) + strlen($3) + strlen($5)) * sizeof(char));
                                        strcpy($$, "Int ");
                                        strcat($$, $1);
                                        strcat($$, "=int_add(");
                                        strcat($$, $3);
                                        strcat($$, ", int_create(1));");
                                        strcat($$, $1);
                                        strcat($$, ".value<=");
                                        $5 = recover_value($5);
                                        strcat($$, $5);
                                        strcat($$, ";");
                                        strcat($$, $1);
                                        strcat($$, ".value++");

                                    }
    | name TK_IN num TK_FOR_EXC_EXC num 
                                    {
                                        $1 = strdup($1);
                                        free($$);
                                        $$ = malloc((53 + (3 * strlen($1)) + strlen($3) + strlen($5)) * sizeof(char));
                                        strcpy($$, "Int ");
                                        strcat($$, $1);
                                        strcat($$, "=int_add(");
                                        strcat($$, $3);
                                        strcat($$, ", int_create(1));");
                                        strcat($$, $1);
                                        strcat($$, ".value<");
                                        $5 = recover_value($5);
                                        strcat($$, $5);
                                        strcat($$, ";");
                                        strcat($$, $1);
                                        strcat($$, ".value++");

                                    }
;

func_exec_param:
                                    { $$ = strdup(""); }
    | value                         { $$ = strdup($1); }
    | value TK_COMMA func_exec_param     
                                    {
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
    | name TK_DOT name TK_OPEN_BRACKET func_exec_param TK_CLOSE_BRACKET     {
                                    $1 = strdup($1);
                                    free($$);
                                    $$ = malloc((4 + strlen($1) + strlen($3) + strlen($5)) * sizeof(char));
                                    strcpy($$, $1);
                                    strcat($$, ".");
                                    strcat($$, $3);
                                    strcat($$, "(");
                                    strcat($$, $5);
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
    TK_OPEN_BRACE commands TK_CLOSE_BRACE   {
                                                free($$);
                                                $$ = malloc((3 + strlen($2)) * sizeof(char));
                                                strcpy($$, "{");
                                                strcat($$, $2);
                                                strcat($$, "}");
                                            }
;


logic_op:
    TK_LOP_BIGGER                   { $$ = strdup(">"); }
    | TK_LOP_SMALLER                { $$ = strdup("<"); }
    | TK_EQUALS TK_EQUALS           { $$ = strdup("=="); }
    | TK_LOP_BIGGER TK_EQUALS       { $$ = strdup(">="); }
    | TK_LOP_SMALLER TK_EQUALS      { $$ = strdup("<="); }


value_bool:
    TK_VAL_TRUE                     { $$ = strdup("1"); }
    | TK_VAL_FALSE                  { $$ = strdup("0"); }
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

num:
    | TK_VAL_INT                    {
                                        free($$);
                                        $$ = strdup("int_create(");
                                        strcat($$, strdup(yytext));
                                        strcat($$, ")");
                                    }
    | TK_VAL_FLOAT                  {
                                        free($$);
                                        $$ = strdup("float_create(");
                                        strcat($$, strdup(yytext));
                                        strcat($$, ")");
                                    }
;

value:
    func_exec
    | TK_VAL_STRING                 { $$ = strdup(yytext); }
    | name
    | num
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

char *recover_value(char* s) 
{
    int i = 0;

    do {
        i++;
    } while (s[i] != '(' );

    int j = i;

    while (s[i] != ')' ) {
        i++;
    }

    char *aux = malloc((i - j) * sizeof(char));

    int k = 0;

    while (j + 1 < i) {
        aux[k] = s[j + 1];
        k++;
        j++;
    }

    aux[k] = '\0';

    return aux;
}