#include "compiler.h"
#include <stdlib.h>
#include <string.h>

Symbol * create_symbol(char *name, char *type, char *cname, Symbol *next) {
    Symbol *s = malloc(sizeof(Symbol));
    s->name = name;
    s->type = type;
    s->cname = cname;
    s->next = next;
    return s;
}

Symbol * search_symbol(Symbol *list, char *name) {
    for(Symbol *s = list; s != NULL; s = s->next) {
        if(strcmp(s->name, name) == 0)
            return s;
    }
    return NULL;
}
