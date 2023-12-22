#include "basic.h"
#include <stdio.h>
int main()
{
    Circle a = circle_create(float_create(3.0), vector2_create(float_create(.0), float_create(8.0)));
    Circle b = circle_create(float_create(10.0), vector2_create(float_create(13.0), float_create(8.0)));
    Circle c = circle_create(float_create(2.0), vector2_create(float_create(15.0), float_create(8.0)));
    Circle d = circle_create(float_create(2.0), vector2_create(float_create(.0), float_create(2.0)));
    Circle e = circle_create(float_create(0.0), vector2_create(float_create(33.0), float_create(8.0)));
    Int collision = int_create(1);
    Float increment = float_create(.5);
    while (collision.value)
    {
        collision = int_create(0);
        e.radius = float_add(e.radius, increment);
        printf("Raio: %s\n", e.radius.to_str(e.radius));
        if (e.collide(e, a))
        {
            printf("C5 E C1 colidem!\n");
        }
        else if (e.collide(e, b))
        {
            printf("C5 E C2 colidem!\n");
        }
        else if (e.collide(e, c))
        {
            printf("C5 e C3 colidem!\n");
        }
        else if (e.collide(e, d))
        {
            printf("C5 e C4 colidem!\n");
        }
        else
        {
            printf("Sem colisoes\n");
            collision = int_create(1);
        }
    }
}