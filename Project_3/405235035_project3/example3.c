#include <stdlib.h>
#include <stdio.h>

void main()
{
	float a;
	float b;
	int c;
	float d;

	a = 3.14;
	b = 8.88;
	c = 5;

	printf("a = %f\n",a);
	printf("b = %f\n",b);
	printf("c = %d\n",c);

	d = -a*b;
	printf("-a*b = %f\n",d);

	d = a*c;
	printf("a*c = %f\n",d);

	return;
}
