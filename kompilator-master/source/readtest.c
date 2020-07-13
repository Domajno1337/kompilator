#include <stdlib.h>
#include <string.h>
#include <stdio.h>

int main(){
	FILE *code;
	code = fopen("rpn.txt", "r");

	char symbols;
	while ((symbols = fgetc(code)) != EOF) printf("%c\n", symbols);

	return 0;
}

