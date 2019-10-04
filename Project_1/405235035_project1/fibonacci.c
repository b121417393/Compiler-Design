#include <stdlib.h>
#include <stdio.h>

int main()
{
	int a = 0, b = 1, result;
	int i = 0;

	for(i = 2 ; i <= 10 ; i++)
	{
		result = a + b;
		a = b;
		b = result;
	}

	printf("fibonacci 10 = %d\n",result);
	return 0;
}
