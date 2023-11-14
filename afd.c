//
//  afd.c
//  Compiler
//
//  Created by Emanuel on 14/11/23.
//

#include "afd.h"
#include <stdlib.h>
#include <stdio.h>

AFD * create_afd(unsigned int n, unsigned int final) {
    AFD *afd = malloc(sizeof(AFD));
    afd->transitions = malloc(n * sizeof(Node));
    for(int i = 0; i < n; i++) {
        afd->transitions[i] = NULL;
    }
    afd->n = n;
    afd->final = final;
    
    return afd;
}

Node * create_node(char symbol, char add, char remove, unsigned int state, Node *next) {
    Node *node = malloc(sizeof(Node));
    node->symbol = symbol;
    node->add = add;
    node->remove = remove;
    node->state = state;
    node->next = next;

    return node;
}

Memory * add_memory(char symbol, Memory *next) {
    Memory *memory = malloc(sizeof(Memory));
    memory->symbol = symbol;
    memory->next = next;

    return memory;
}

Memory * remove_memory(Memory *memory, char symbol) {
    if(memory != NULL) {
        if(memory->symbol == symbol) {
            Memory *aux = memory;
            memory = memory->next;
            free(aux);
            return memory;
        }
    }
    return NULL;
}

void add_transition(AFD *afd, unsigned int at_state, char symbol, char add, char remove, unsigned int to_state) {
    Node *node = malloc(sizeof(Node));
    node->symbol = symbol;
    node->add = add;
    node->remove = remove;
    node->state = to_state;
    node->next = afd->transitions[at_state];

    afd->transitions[at_state] = node;
}

void show_transitions(AFD *afd) {
    for(int i = 0; i < afd->n; i++) {
        for(Node *n = afd->transitions[i]; n != NULL; n = n->next) {
            printf("%c: %d -> %d\n", n->symbol, i, n->state);
        }
    }
}

unsigned int match(AFD *afd, const char *file_name) {
    FILE *file = fopen(file_name, "rt");
    Memory *memory = NULL;

    if(file != NULL) {
        unsigned int state = 0;
        for(char ch = fgetc(file); ch != EOF; ch = fgetc(file)) {
            for(Node *node = afd->transitions[state]; node != NULL; node = node->next) {
                if(ch == '\n')
                    continue;
                if(node->symbol == ch) {
                    if(node->add != '\0') {
                        memory = add_memory(node->add, memory);
                    } else if (node->remove != '\0') {
                        if(memory == NULL) {
                            return 0;
                        }
                        memory = remove_memory(memory, node->remove);
                    }
                    state = node->state;
                    printf("%c -> %d\n", ch, state);
                    break;
                } else if(node->next == NULL) {
                    return 0;
                }
            }
        }

        return state == afd->final && memory == NULL;
    }
    return 0;
}

int main(int argc, char *argv[]) {
    AFD *a = create_afd(9, 9); // Valida CPF
    
    for (char d = '0'; d <= '9'; d++) {
        a->transitions[0] = create_node(d, '\0', '\0', 1, a->transitions[0]);
        a->transitions[1] = create_node(d, '\0', '\0', 2, a->transitions[1]);
        a->transitions[2] = create_node(d, '\0', '\0', 3, a->transitions[2]);
        a->transitions[3] = create_node(d, '\0', '\0', 4, a->transitions[3]);
        a->transitions[4] = create_node(d, '\0', '\0', 5, a->transitions[4]);
        a->transitions[5] = create_node(d, '\0', '\0', 8, a->transitions[5]);
        a->transitions[6] = create_node(d, '\0', '\0', 7, a->transitions[6]);
        a->transitions[7] = create_node(d, '\0', '\0', 8, a->transitions[7]);
        a->transitions[8] = create_node(d, '\0', '\0', 9, a->transitions[8]);
    }
    a->transitions[5] = create_node('-', '\0', '\0', 6, a->transitions[5]);
    
    printf("%d\n", match(a, "file.txt"));
}
