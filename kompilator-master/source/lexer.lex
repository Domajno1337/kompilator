%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "gram.tab.h"
	FILE *out;
	FILE *code;
	FILE *readcode;
	FILE *rpn;
	extern void getRpn();
%}

%%
"liczba" return INT;
"jezeli" return IF;
"wtedy" return THEN;
"w przeciwnym wypadku" return ELSE;
"dopoki" return WHILE;
"wykonaj" return DO;
"wyswietl" return READ;
"(" return LPAR;
")" return RPAR;
"{" return LCBRA;
"}" return RCBRA;
"+" return ADD;
"-" return SUB;
"*" return MUL;
"/" return DIV;
"=" return ASSIGN;
"==" return EQ;
"!=" return NOTEQ;
">" return GT;
"<" return LT;
">=" return GTEQ;
"<=" return LTEQ;
"i" return AND;
"lub" return OR;
"//".*"\n" return COM;
[a-zA-z][a-zA-Z0-9]* {yylval = *yytext; return VAR;}
[0-9]+ {yylval = atoi(yytext); return NUM;}
%%

int main(int argc, char const *argv[]){
	if (argc > 1){
		yyin = fopen(argv[1], "r");
		if (yyin){
			printf("\033[0;33m");
			printf("Trwa kompilowanie kodu: %s\nProszę czekać...\n", argv[1]);
			printf("\033[0m");
			out = fopen("temp.asm", "w");
			rpn = fopen("rpn.txt", "w");
			code = fopen("code.txt", "w");

			char symbols[] = "2+3*5-1";
			getRpn(symbols);

			yyparse();
			fclose(out); 
			fclose(yyin);
		} else { printf("Nie można otworzyć pliku!\n"); }
	} return 0;
}
