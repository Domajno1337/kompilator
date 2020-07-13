#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <ctype.h>
#define MAX_SIZE 64

/* Generowanie odwrotnej notacji polskiej - wersja poprawiona */

FILE *out;

typedef struct STACK{
	int top;
	char *items;
}* stack;

stack newStack(){
	stack temp = malloc(sizeof(stack));
	temp->top = -1;
	temp->items = malloc(sizeof(char) * MAX_SIZE);
	return temp;
}

void push(char item, stack st){
	if(st->top != MAX_SIZE-1){
		st->top++;
		st->items[st->top] = item;
	} else printf("Stos jest pełny!\n");
}

char pop(stack st){
	char lastItem;
	if(st->top != -1){
		lastItem = st->items[st->top];
		st->top--;
	} return lastItem;
}

int isOperator(char symbol){
	switch(symbol){
		case '+':
		case '-':
		case '*':
		case '/':
			return 1;
			break;
		default:
			return 0;
			break;
	}
}

int getPriority(char symbol){
	if(symbol == '+' || symbol == '-') return 0;
	else if (symbol == '*' || symbol == '/') return 1;
	else return -1;
}

int main(){
	stack st = newStack();
	char expr[] = "2+3*5-1";
	push('(', st); strcat(expr, ")");
	out = fopen("rpn.txt", "w");

	/* Odwrotna notacja polska */
	char item;
	for(int i=0; expr[i] != '\0'; i++){
		if(expr[i] == '(') push(expr[i], st);
		else if (isalnum(expr[i])) fprintf(out, "%c\n", expr[i]);
		else if (expr[i] == ')'){
			item = pop(st);
			while(item != '('){
				fprintf(out, "%c\n", item);
				item = pop(st);
			}
		} else if (isOperator(expr[i]) == 1){
			item = pop(st);
			while(isOperator(item) == 1 && (getPriority(item) >= getPriority(expr[i]))){
				fprintf(out, "%c\n", item);
				item = pop(st);
			} push(item, st); push(expr[i], st);
		}
	} fclose(out);
	return 0;
}
