//
//  afd.h
//  Compiler
//
//  Created by Emanuel on 14/11/23.
//

#ifndef afd_h
#define afd_h

typedef struct node {
    char symbol;
    char add;
    char remove;
    unsigned int state;
    struct node *next;
} Node;

typedef struct {
    Node **transitions;
    unsigned int n;
    unsigned int final;
} AFD;

typedef struct memory {
    char symbol;
    struct memory *next;
} Memory;

AFD * create_afd(unsigned int n, unsigned int final);

Node * create_node(char symbol, char add, char remove, unsigned int state, Node *next);

Memory * add_memory(char symbol, Memory *next);

Memory * remove_memory(Memory *memory, char symbol);

void add_transition(AFD *afd, unsigned int at_state, char symbol, char add, char remove, unsigned int to_state);

void show_transitions(AFD *afd);

unsigned int match(AFD *afd, const char *file_name);

#endif /* afd_h */
