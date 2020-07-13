%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "gram.tab.h"
	FILE *out;
%}

%%
"liczba" return INT;
"jezeli" return IF;
"wtedy" return THEN;
"w przeciwnym wypadku" return ELSE;
"dopoki" return WHILE;
"wykonaj" return DO;
"wyswietl" return READ;
"+" return PLUS;
"-" return MINUS;
"*" retrun STAR;
"\\" return SLASHS;
"\" return SLASH;
"=" return ASSIGN;
"==" return EQ;
"!=" return NOTEQ;
">" return GR;
">=" return GREQ;
"<" return LT;
"<=" return LTEQ;
"("  return LPAREN;
")"  return RPAREN;
"["  return LQPAREN;
"]"  return RQPAREN;
"{" return LBRACE;
"}" return RBRACE;
"i" return AND;
"++" return INCR;
"-=" return MINUSassign;
"!" return NOT;
"+=" return PLUSassign;
"--" return DECR;
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
			out = fopen("temp.txt","w");
			yyparse();
			fclose(out); 
			fclose(yyin);
		} else { printf("Nie można otworzyć pliku!\n"); }
	} return 0;
}
