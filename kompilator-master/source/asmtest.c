#include <stdio.h>

int main(){
	/* Składnia AT&T */
	int x = 2, y = 3, result;
	asm("addl %%ebx, %%eax"
	: "=a" (result)
	: "a"(x), "b"(y)
	);
	
	printf("2 + 3 = %d", result);
	return 0;
}
