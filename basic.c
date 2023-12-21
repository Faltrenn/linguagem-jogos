#include "basic.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

Int int_create(int value) {
    Int i;
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
Int int_div(Int a, Int b) { return int_create(a.value / b.value); }
char * int_to_str(Int a) {
    char *str = malloc(((int)(ceil(log10(a.value))) + 1) * sizeof(char));
    sprintf(str, "%d", a.value);
    return str;
}

Float float_create(float value) {
    Float i;
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
Float float_div(Float a, Float b) { return float_create(a.value / b.value); }
char * float_to_str(Float a) {
    char *str = malloc(((int)(ceil(log10(a.value))) + 1) * sizeof(char));
    sprintf(str, "%f", a.value);
    return str;
}

Vector2 vector2_create(Float x, Float y) {
    Vector2 v;
    v.x = x;
    v.y = y;
    v.add = &vector2_add;
    v.sub = &vector2_sub;
    v.to_str = &vector2_to_str;
    return v;
}

Vector2 vector2_add(Vector2 a, Vector2 b) { return vector2_create(a.x.add(a.x, b.x), a.y.add(a.y, b.y)); }
Vector2 vector2_sub(Vector2 a, Vector2 b) { return vector2_create(a.x.sub(a.x, b.x), a.y.sub(a.y, b.y)); }

char * vector2_to_str(Vector2 a) {
    char *x_str = a.x.to_str(a.x);
    char *y_str = a.y.to_str(a.y);
    int tam_x = strlen(x_str);
    int tam_y = strlen(y_str);
    char *str = malloc((tam_x + tam_y + 5) * sizeof(char));
    sprintf(str, "(%s, %s)", x_str, y_str);
    free(x_str);
    free(y_str);
    return str;
}

Circle circle_create(Float radius, Vector2 position) {
    Circle c;
    c.radius = radius;
    c.position = position;
    c.collides = & circle_collides;

    return c;
}

unsigned int circle_collides(Circle a, Circle b) {
    float c1 = a.position.x.value - b.position.x.value;
    float c2 = a.position.y.value - b.position.y.value;
    float offset = sqrt(c1*c1 + c2*c2);
    return offset <= (a.radius.value + b.radius.value);
}
