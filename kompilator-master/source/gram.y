%{
	#include <string.h>
	#include <stdlib.h>
	#include <ctype.h>
	#include <stdio.h>
	#define MAX_SIZE 64
	extern FILE *out;
	extern FILE *code;
	extern FILE *rpn;
	extern char *yytext;
	int ln = 0;
	int data[255];

	/* Wstawki assemblerowe muszą być składni AT&T! */

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

	void getRpn(char expr[]){
		stack st = newStack();
		//char expr[] = "(2+1)*3-4*(7+4)";
		push('(', st); strcat(expr, ")");

		char item;
		for(int i=0; expr[i] != '\0'; i++){
			if(expr[i] == '(') push(expr[i], st);
			else if (isalnum(expr[i])) fprintf(rpn, "%c\n", expr[i]);
			else if (expr[i] == ')'){
				item = pop(st);
				while(item != '('){
					fprintf(rpn, "%c\n", item);
					item = pop(st);
				}
			} else if (isOperator(expr[i]) == 1){
				item = pop(st);
				while(isOperator(item) == 1 && (getPriority(item) >= getPriority(expr[i]))){
					fprintf(rpn, "%c\n", item);
					item = pop(st);
				} push(item, st); push(expr[i], st);
			}
		}
	}
%}

%token INT IF THEN ELSE READ WHILE DO LPAR RPAR LCBRA RCBRA ASSIGN NOTEQ GT LT GTEQ LTEQ AND OR COM VAR NUM
%left ADD SUB
%left DIV MUL
%nonassoc EQ

%%
input: line 
	| input line
;
line: comment {ln++;}
	| init {ln++;}
	| decl {ln++;}
	| show {ln++;}
	| ifbody {ln++;}
	| whilebody {ln++;}
;
comment: COM {fprintf(out, "Komentarz: %s", yytext);}
;
init: INT VAR {fprintf(code, "%s\n", yytext);}
	| INT decl  
;
decl: VAR ASSIGN expr {
	data[$1] = $3; 
	$$ = $1;
}
;
show: READ VAR {fprintf(out, "%c wynosi %d\n", $2, data[$2]);} 
;
expr: NUM {fprintf(code, "%s\n", yytext);}
	| expr ADD {fprintf(code, "%s\n", yytext);} expr {
		asm("addl %%ebx, %%eax"
		: "=a" ($$)
		: "a"($1), "b"($3)
		);
	}
	| expr SUB {fprintf(code, "%s\n", yytext);} expr {
		asm("subl %%ebx, %%eax"
		: "=a" ($$)
		: "a"($1), "b"($3)
		);
	}
	| expr MUL {fprintf(code, "%s\n", yytext);} expr {
		asm("imull %%ebx, %%eax"
		: "=a" ($$)
		: "a"($1), "b"($3)
		);
	}
	| expr DIV {fprintf(code, "%s\n", yytext);} expr {
		asm("divl %%ecx, %%eax"
		: "=a" ($$)
		: "a" ($1), "b"($3)
		); $$ = $1 / $3;
	}
;
ifbody: IF LPAR con RPAR THEN ifstatement
;
con: conexpr
	| con AND con
	| con OR con
;
conexpr: NUM
	| VAR
	| conexpr GT conexpr
	| conexpr GTEQ conexpr
	| conexpr LT conexpr
	| conexpr LTEQ conexpr
	| conexpr EQ conexpr
	| conexpr NOTEQ conexpr
;
ifstatement: LCBRA statement RCBRA
	| ELSE LCBRA statement RCBRA
;
statement: line
;
whilebody: WHILE LPAR conexpr RPAR DO LCBRA statement RCBRA
;
%%

int yyerror(char *msg){
	printf("\033[1;31m");
	printf("Nr linii %d: %s\n", ln, msg);
	printf("\033[0m\n");
	return -1;	
}
