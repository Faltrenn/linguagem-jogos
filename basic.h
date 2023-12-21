typedef struct Int {
    unsigned int type;
    int value;

    struct Int (*add) (struct Int, struct Int);
    struct Int (*sub) (struct Int, struct Int);
    struct Int (*mul) (struct Int, struct Int);
    struct Int (*div) (struct Int, struct Int);
    char * (*to_str) (struct Int);
} Int;

Int int_create(int);
Int int_add(Int, Int);
Int int_sub(Int, Int);
Int int_mul(Int, Int);
Int int_div(Int, Int);
char * int_to_str(Int);

typedef struct Float {
    unsigned int type;
    float value;

    struct Float (*add) (struct Float, struct Float);
    struct Float (*sub) (struct Float, struct Float);
    struct Float (*mul) (struct Float, struct Float);
    struct Float (*div) (struct Float, struct Float);
    char * (*to_str) (struct Float);
} Float;

Float float_create(float);
Float float_add(Float, Float);
Float float_sub(Float, Float);
Float float_mul(Float, Float);
Float float_div(Float, Float);
char * float_to_str(Float);

typedef struct Vector2 {
    Float x;
    Float y;

    struct Vector2 (*add) (struct Vector2, struct Vector2);
    struct Vector2 (*sub) (struct Vector2, struct Vector2);
    char * (*to_str) (struct Vector2);
} Vector2;

Vector2 vector2_add(Vector2, Vector2);
Vector2 vector2_sub(Vector2, Vector2);
char * vector2_to_str(Vector2);

typedef struct Circle {
    Float radius;
    Vector2 position;

    unsigned int (*collides) (struct Circle, struct Circle);
} Circle;

Circle circle_create(Float, Vector2);
unsigned int circle_collides(Circle, Circle);
