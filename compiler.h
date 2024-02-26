typedef struct symbol {
    char *name;
    char *type;
    char *cname;
    struct symbol *next;
} Symbol;

Symbol * create_symbol(char *name, char *type, char *cname, Symbol *next);
Symbol * search_symbol(Symbol *list, char *name);
