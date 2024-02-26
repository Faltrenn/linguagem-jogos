%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "compiler.h"

#define YYSTYPE char *

extern char *yytext;
extern int yylex(void);
extern int yyerror(char* s);

FILE *file;

char * var_create(char *type, char *name) {
    char *var = malloc((2 + strlen(type) + strlen(name)) * sizeof(char));
    strcpy(var, type);
    strcat(var, " ");
    strcat(var, name);
    return var;
}

char * attribute(char *n1, char *n2) {
    char *attr = malloc((2 + strlen(n1) + strlen(n2)) * sizeof(char));
    strcpy(attr, n1);
    strcat(attr, ".");
    strcat(attr, n2);

    return attr;
}
char * list_values(char *v1, char *v2) {
    char *l_values = malloc((2 + strlen(v1) + strlen(v2)) * sizeof(char));
    strcpy(l_values, v1);
    strcat(l_values, ",");
    strcat(l_values, v2);

    return l_values;
}
char * exec_params(char *list) {
    char *e_params = malloc((3 + strlen(list)) * sizeof(char));
    strcpy(e_params, "(");
    strcat(e_params, list);
    strcat(e_params, ")");

    return e_params;
}
char * func_exec(char *name, char *e_parameters) {
    char *f_exec = malloc((1 + strlen(name) + strlen(e_parameters)) * sizeof(char));
    strcpy(f_exec, name);
    strcat(f_exec, e_parameters);

    return f_exec;
}

char * command(char *c) {
    char *cmd = malloc((2 + strlen(c)) * sizeof(char));
    strcpy(cmd, c);
    strcat(cmd, ";");

    return cmd;
}

char * commands(char *c1, char *c2) {
    char *cmds = malloc((1 + strlen(c1) + strlen(c2)) * sizeof(char));
    strcpy(cmds, c1);
    strcat(cmds, c2);

    return cmds;
}

char * one_param(char *type, char *name) {
    char *l_params = malloc((2 + strlen(type) + strlen(name)));
    strcpy(l_params, type);
    strcat(l_params, " ");
    strcat(l_params, name);

    return l_params;
}

char * stack_params(char *params, char *type, char *name) {
    char *l_params = malloc((2 + strlen(params) +  strlen(type) + strlen(name)));
    strcpy(l_params, params);
    strcat(l_params, ",");
    strcat(l_params, type);
    strcat(l_params, " ");
    strcat(l_params, name);

    return l_params;
}

char * func_create(char *name, char *params, char *return_type, char *block) {
    char *func = malloc((1 + strlen(name) + strlen(params) + strlen(return_type) + strlen(block)) * sizeof(char));
    strcpy(func, return_type);
    strcat(func, " ");
    strcat(func, name);
    strcat(func, params);
    strcat(func, block);

    return func;
}

char * create_params(char *params) {
    char *c_params = malloc((3 + strlen(params)) * sizeof(char));
    strcpy(c_params, "(");
    strcat(c_params, params);
    strcat(c_params, ")");

    return c_params;
}

char * block(char *commands) {
    char *block = malloc((3 + strlen(commands)) * sizeof(char));
    strcpy(block, "{");
    strcat(block, commands);
    strcat(block, "}");

    return block;
}

char * math_operation(char *value1, char *operator, char *value2) {
    char *m_operation = malloc((2 + strlen(value1) + strlen(value2)) * sizeof(char));
    strcpy(m_operation, value1);
    strcat(m_operation, operator);
    strcat(m_operation, value2);

    return m_operation;
}

char * _return(char * value) {
    char *rtrn = malloc((8 + strlen(value)) * sizeof(char));
    strcpy(rtrn, "return ");
    strcat(rtrn, value);

    return rtrn;
}
%}

%token TK_VAR
%token TK_EQUALS
%token TK_FUNC TK_FUNC_RTRN TK_RTRN
%token TK_OPN_BRACK TK_CLS_BRACK TK_OPN_BRACE TK_CLS_BRACE
%token TK_VAL_INT TK_VAL_FLOAT TK_VAL_STRING
%token TK_MOP_PLUS TK_MOP_MINUS
%token TK_NAME
%token TK_DOT TK_COMMA

%%
program:
    func_create                                         {   fprintf(file, "%s", $1);                }
    | program func_create                               {   fprintf(file, "%s", $2);                }
;

func_create:
    TK_FUNC name create_params block                    {   $$ = func_create($2, $3, "void", $4);   }
    | TK_FUNC name create_params TK_FUNC_RTRN name block{   $$ = func_create($2, $3, $5, $6);       } 
;

block:
    TK_OPN_BRACE commands TK_CLS_BRACE                  {   $$ = block($2);                         }
    | TK_OPN_BRACE TK_CLS_BRACE                         {   $$ = block("");                         }
;

create_params:
    TK_OPN_BRACK list_params TK_CLS_BRACK               {   $$ = create_params($2);                 }
;

list_params:
                                                        {   $$ = strdup("");                        }
    | name name                                         {   $$ = one_param($1, $2);                 }
    | list_params TK_COMMA name name                    {   $$ = stack_params($1, $3, $4);          }
;

commands:
    command                                             {   $$ = strdup($1);                        }
    | commands command                                  {   $$ = commands($1, $2);                  }
;

command:
    func_exec                                           {   $$ = command($1);                       }
    | TK_RTRN operation                                 {   $$ = command(_return($2));              }
    | TK_VAR name name                                  {   $$ = command(var_create($2, $3));       }
;

func_exec:
    name exec_params                                    {   $$ = func_exec($1, $2);                 }
    | attribute exec_params                             {   $$ = func_exec($1, $2);                 }
;

exec_params:
    TK_OPN_BRACK list_values TK_CLS_BRACK               {   $$ = exec_params($2);                   }
;

list_values:
                                                        {   $$ = strdup("");                        }
    | operation                                         {   $$ = strdup($1);                        }
    | list_values TK_COMMA operation                    {   $$ = list_values($1, $3);               }
;

operation:
    value                                               {   $$ = strdup($1);                        }
    | value math_operator operation                     {   $$ = math_operation($1, $2, $3);        }

value:
    number                                              {   $$ = strdup($1);                        }
    | TK_VAL_STRING                                     {   $$ = strdup(yytext);                    }
    | attribute                                         {   $$ = strdup($1);                        }
    | name /* Variável */                               {   $$ = strdup($1);                        }
    | func_exec                                         {   $$ = strdup($1);                        }
;

math_operator:
    TK_MOP_MINUS                                        {   $$ = strdup("-");                       }
    | TK_MOP_PLUS                                       {   $$ = strdup("+");                       }
;

number:
    TK_VAL_INT                                          {   $$ = strdup(yytext);                    }
    | TK_VAL_FLOAT                                      {   $$ = strdup(yytext);                    }
;

attribute:
    name TK_DOT name                                    {   $$ = attribute($1, $3);                 }
    | attribute TK_DOT name                             {   $$ = attribute($1, $3);                 }
;

name:
    TK_NAME                                             {   $$ = strdup(yytext);                    }
;
%%

int main(int argc, char **argv)
{
    file = fopen("code.c", "w");
    fprintf(file, "#include <stdio.h>\n");

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
