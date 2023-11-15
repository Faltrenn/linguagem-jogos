//
//  compiler.c
//  Compiler
//
//  Created by Emanuel on 15/11/23.
//

#include "compiler.h"
#include <stdio.h>

void make_transitions(AFD *a) {
    add_transition(a, 0, ' ', '\0', '\0', 0, 0);
        
    add_transition(a, 0, 'i', '\0', '\0', 1, 0); // Palavra chave
    add_transition(a, 1, 'n', '\0', '\0', 2, 0);
    add_transition(a, 2, 'c', '\0', '\0', 3, 0);
    add_transition(a, 3, 'l', '\0', '\0', 4, 0);
    add_transition(a, 4, 'u', '\0', '\0', 5, 0);
    add_transition(a, 5, 'd', '\0', '\0', 6, 0);
    add_transition(a, 6, 'e', '\0', '\0', 7, 0);
    add_transition(a, 7, ' ', '\0', '\0', 8, 1);
    
    add_transition(a, 8, '_', '\0', '\0', 9, 1); // Primeiro nome: função ou classe ou biblioteca
    add_transition(a, 8, '"', '\0', '\0', 26, 0);
    add_transition(a, 26, '"', '\0', '\0', 27, 0);
    add_transition(a, 26, '"', '\0', '\0', 20, 0);
    
    add_transition(a, 9, ';', '\0', '\0', 0, 0);
    add_transition(a, 9, ',', '\0', '\0', 11, 0); // Primeiro nome vira lista de funções e classes
    add_transition(a, 9, ' ', '\0', '\0', 10, 1);
    add_transition(a, 10, ';', '\0', '\0', 0, 0);
    add_transition(a, 10, 'a', '\0', '\0', 21, 0);
    add_transition(a, 10, ',', '\0', '\0', 11, 0);
    add_transition(a, 11, ' ', '\0', '\0', 11, 0);
    add_transition(a, 11, '_', '\0', '\0', 12, 1);
    add_transition(a, 12, ',', '\0', '\0', 11, 0);
    add_transition(a, 12, ' ', '\0', '\0', 13, 1);
    add_transition(a, 13, ',', '\0', '\0', 11, 0);
    add_transition(a, 13, 'f', '\0', '\0', 14, 0);
    add_transition(a, 14, 'r', '\0', '\0', 15, 0);
    add_transition(a, 15, 'o', '\0', '\0', 16, 0);
    add_transition(a, 16, 'm', '\0', '\0', 17, 0); // Segundo nome: Biblioteca
    add_transition(a, 17, ' ', '\0', '\0', 18, 1);
    add_transition(a, 18, '_', '\0', '\0', 19, 1);
    add_transition(a, 18, '"', '\0', '\0', 26, 0);
    add_transition(a, 19, ' ', '\0', '\0', 20, 1);
    add_transition(a, 19, ';', '\0', '\0', 0, 0);
    add_transition(a, 20, ';', '\0', '\0', 0, 0);
    add_transition(a, 20, 'a', '\0', '\0', 21, 0);
    add_transition(a, 21, 's', '\0', '\0', 22, 0); // Terceiro nome: Apelido
    add_transition(a, 22, ' ', '\0', '\0', 23, 1);
    add_transition(a, 23, '_', '\0', '\0', 24, 1);
    add_transition(a, 24, ';', '\0', '\0', 0, 0);
    add_transition(a, 24, ' ', '\0', '\0', 25, 1);
    add_transition(a, 24, ';', '\0', '\0', 0, 0);
    add_transition(a, 25, ';', '\0', '\0', 0, 0);
    
    for(int c = 'a'; c <= 'z'; c++) { // Letras
        add_transition(a, 8, c, '\0', '\0', 9, 1);
        add_transition(a, 8, c-32, '\0', '\0', 9, 1);
        add_transition(a, 11, c, '\0', '\0', 12, 1);
        add_transition(a, 11, c-32, '\0', '\0', 12, 1);
        add_transition(a, 18, c, '\0', '\0', 19, 1);
        add_transition(a, 18, c-32, '\0', '\0', 19, 1);
        add_transition(a, 23, c, '\0', '\0', 24, 1);
        add_transition(a, 23, c-32, '\0', '\0', 24, 1);
    }
    
    for(int i = '0'; i <= '9'; i++) { // Números
        add_transition(a, 9, i, '\0', '\0', 9, 0);
        add_transition(a, 12, i, '\0', '\0', 12, 0);
        add_transition(a, 19, i, '\0', '\0', 19, 0);
        add_transition(a, 24, i, '\0', '\0', 24, 0);
    }
    
    for (int i = 32; i <= 126; i++) { // Tabela ASCII - Caracteres
        if (i == '"')
            continue;
        add_transition(a, 26, i, '\0', '\0', 26, 0);
    }
}

int main(int argc, char *argv[]) {
    AFD *a = create_afd(27, 0);
    make_transitions(a);
    
    printf("%d\n", match(a, argv[1]));
}
