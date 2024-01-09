typedef void * (math_operation) (void *, void *);

typedef struct Object {
    math_operation *add;
    math_operation *sub;
    math_operation *mul;
    math_operation *div;
    char * (*to_str) (void *a);
} Object;

typedef struct Int {
    Object obj;
    int value;
} Int;

void * int_new(int);
void * int_add(void *, void *);
void * int_sub(void *, void *);
void * int_mul(void *, void *);
void * int_div(void *, void *);
char * int_to_str(void *);

typedef struct Hash {
    char *key;
    char *value;
    struct Hash *next;
} Hash;
