%{
	#include <string.h>
	#include <stdlib.h>
	#include <stdio.h>
	extern FILE *out;
	extern char *yytext;
	int ln = 0;
	int data[255];
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
init: INT VAR
	| INT decl  
;
decl: VAR ASSIGN expr {data[$1] = $3; $$ = $1;}
;
show: READ VAR {fprintf(out, "%c wynosi %d\n", $2, data[$2]);} 
;
expr: NUM
	| expr ADD expr {$$ = $1 + $3;}
	| expr SUB expr {$$ = $1 - $3;}
	| expr MUL expr {$$ = $1 * $3;}
	| expr DIV expr {$$ = $1 / $3;}
;
ifbody: IF LPAR con RPAR THEN ifstatement
;
con: conexpr
	| con AND con
	| con OR con
;
conexpr: NUM
	| VAR
	| expr GT expr
	| expr GTEQ expr
	| expr LT expr
	| expr LTEQ expr
	| expr EQ expr
	| expr NOTEQ expr
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
