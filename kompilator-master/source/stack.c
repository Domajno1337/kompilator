#include <stdlib.h>
#include <stdio.h>

#define MAXSIZE 32

struct stack{
    char data;
    struct stack* top;
}; typedef struct stack* STACK;

void push(char element, STACK* source){
	STACK temp = (STACK)malloc(sizeof(struct stack));
	temp->data = element;
	temp->top = *source;
	(*source) = temp;
}

void pop(STACK* source){
    if(*source != NULL){
        STACK temp = *source;
        *source = (*source)->top;
        free(temp);
    }
}

int main(){
	STACK example = (STACK)malloc(sizeof(struct stack));
	example->data = 'x';
	example->top = NULL;
	printf("%c\n", example->data);
	push('y', &example);
	printf("%c\n", example->data);
	pop(&example);
	printf("%c\n", example->data);
	return 0;
}
