kompilator : gram.tab.o lex.yy.o
	gcc -o kompilator lex.yy.o gram.tab.o -lfl
lex.yy.o : lex.yy.c
	gcc -c lex.yy.c
lex.yy.c : lexer.lex
	flex lexer.lex
gram.tab.o : gram.tab.c
	gcc -c gram.tab.c
gram.tab.c : gram.y
	bison -d gram.y
clean : rm *.o
