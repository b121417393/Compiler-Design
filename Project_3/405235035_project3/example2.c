#include <stdlib.h>
#include <stdio.h>

void main()
{
	int a;
	int b;

	a;
	b = 100;

	printf("please input a:\n");
	scanf("%d", &a);

	if (a>b){
		printf("a>b is true\n");
		printf("The a is %d\n", a);
		printf("The b is %d\n", b);
	}
	else{
		printf("a>b is false\n");
		printf("The a is %d\n", a);
		printf("The b is %d\n", b);
	}
}
