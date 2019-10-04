#include <stdlib.h>
#include <stdio.h>

int main()
{

        float i;
        float j;
        float k;

        i = 12.0;
        j = 45.0;

        k = i + j;


	if(k > 0.0)
	{
		printf("\n");
		printf("Hello!\n");
		printf("This is then part!\n");
	}

	else
	{
		printf("\n");
		printf("This is else part!\n");
		printf("k = %f",&k);
	}

        return 0;
}

