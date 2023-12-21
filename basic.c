#include "basic.h"
#include "stdio.h"
#include "stdlib.h"
#include "math.h"

Int int_create(int value) {
    Int i;
    i.type = 1;
    i.value = value;
    i.add = &int_add;
    i.sub = &int_sub;
    i.mul = &int_mul;
    i.div = &int_div;
    i.to_str = &int_to_str;
    return i;
}

Int int_add(Int a, Int b) { return int_create(a.value + b.value); }
Int int_sub(Int a, Int b) { return int_create(a.value - b.value); }
Int int_mul(Int a, Int b) { return int_create(a.value * b.value); }
Int int_div(Int a, Int b) { return int_create(a.value / b.value);}
char * int_to_str(Int a) {
    char *str = malloc(((int)(ceil(log10(a.value))) + 1) * sizeof(char));
    sprintf(str, "%d", a.value);
    return str;
}

Float float_create(float value) {
    Float i;
    i.type = 2;
    i.value = value;
    i.add = &float_add;
    i.sub = &float_sub;
    i.mul = &float_mul;
    i.div = &float_div;
    i.to_str = &float_to_str;
    return i;
}

Float float_add(Float a, Float b) { return float_create(a.value + b.value); }
Float float_sub(Float a, Float b) { return float_create(a.value - b.value); }
Float float_mul(Float a, Float b) { return float_create(a.value * b.value); }
Float float_div(Float a, Float b) { return float_create(a.value / b.value);}
char * float_to_str(Float a) {
    char *str = malloc(((int)(ceil(log10(a.value))) + 1) * sizeof(char));
    sprintf(str, "%f", a.value);
    return str;
}
