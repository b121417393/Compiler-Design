#include <stdlib.h>
#include <stdio.h>

int main()
{

        float i;
        float j;
        float k;

        i = 10.0;

        k = i + i;
	k = k * k;

	j = -20.0 + 60.0;

	if(k < j)
	{
		printf("\n");
		printf("Oh yeah! k < j !\n");
		printf("j = %f\n",&j);
		printf("k = %f\n",&k);

	}
	else
	{
		printf("\n");
		printf("Oops! k > j !\n");
		printf("j = %f\n",&j);
		printf("k = %f\n",&k);
	}

        return 0;
}

