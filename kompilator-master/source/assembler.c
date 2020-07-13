#include <stdio.h>

/* Poniższe wstawki assemblerowe nie są zgodne z gcc! */
int main(){
	/* Przypisywanie zmiennych */
	int a;
	__asm__(
		mov ax, 2;
		mov a, ax;
	);

	/* Działania arytmetyczne np. c = a + b */
	int b,c;
	__asm__(
		mov ax, a;
		add ax, b;
		mov c, ax;
	);

	int d = 2, e = 4, max;
	/* Instrukcja warunkowa IF 
		if (d > e) then  max = d else max = e
	*/
	__asm__(
		mov eax, d;
		mov ecx, e;
		cmp eax, ecx;
		jg endif;
		mov eax, ecx;
		endif;
		mov max, eax;
	);

	/* Pętla while 
		while(i<2) do { j++; i++; }
	*/
	int i,j;
	__asm__(
		mov ax, j;
		mov cx, i;
		loop:
		cmp cx, 2;
		je end;
		add ax, cx;
		add cx, 1;
		jmp loop;
		end:
	);

	printf("a wynosi: %d\n", a);
	return 0;
}
