#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>

FILE *out;

struct stack{
	char top;
	struct stack* next;
};

typedef struct stack* STACK;

void push(char data, STACK* src){
	STACK tmp = (STACK)malloc(sizeof(struct stack));
	tmp->top = data;
	tmp->next = *src;
	(*src) = tmp;
}

char getItem(STACK* src){
	char lastItem;
	if (*src != NULL){
		lastItem = (*src)->top;
		STACK tmp = *src;
		*src = (*src)->next;
		free(tmp);
	} return lastItem;
}

int getPriority(char symbol){
	if (symbol == '+' || symbol == '-') return 0;
	else if (symbol == '*' || symbol == '/') return 1;
	else return -1;
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

int main(){
	STACK st = (STACK)malloc(sizeof(struct stack)); st->next = NULL;

	/* Odwrotna notacja polska */
	char expr[] = "2+3*5-1", temp;
	int j=0;

	push('(', &st); strcat(expr, ")");
	out = fopen("rpn.txt", "w");
	for (int i=0; expr[i] != '\0'; i++){
		if (expr[i] == '(') push(expr[i], &st);
		else if (isalnum(expr[i])){
			fprintf(out, "%c\n", expr[i]);
		} else if (expr[i] == ')') {
			temp = getItem(&st);
			while (temp != '('){
				fprintf(out, "%c\n", temp);
				temp = getItem(&st);
			}
		} else if (isOperator(expr[i]) == 1){
			temp = getItem(&st);
			while (isOperator(temp) == 1 && (getPriority(st->top) <= getPriority(temp))){
				fprintf(out, "%c\n", temp);
				temp = getItem(&st);
			} push(temp, &st); push(expr[i], &st);
		}
	} fclose(out);
}
