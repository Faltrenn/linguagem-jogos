#include "basic.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

void * int_create(int value) {
    Int *i = malloc(sizeof(Int));
    i->value = value;
    i->obj.add = &int_add;
    i->obj.to_str = &int_to_str;
    return i;
}

void * int_add(void * a, void * b) {
    Int *n1 = (Int *)a;
    Int *n2 = (Int *)b;
    return int_create(n1->value + n2->value);
}
char * int_to_str(void *a) {
    Int *n = (Int *) a;
    char *str = malloc(((int)(ceil(log10(n->value))) + 1) * sizeof(char));
    sprintf(str, "%d", n->value);
    return str;
}

// int main(void) {
//     char *a = malloc(sizeof(char));
//     // printf("sum: %d\n", ((Int *)int_add(int_create(10), int_create(10)))->value);
//     printf("sum: %s\n", a);
//     return 0;
// }
