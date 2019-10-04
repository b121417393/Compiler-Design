#include <stdlib.h>
#include <stdio.h>

void main()
{
	int num;
	float s;

	printf("Please enter a number:");
	scanf("%d", &num);

	if(num<0){
		printf("Please enter a number>0:");
		scanf("%d", &num);
	}
	else
		printf("%d is a Great number!",num);

	printf("Please enter a number for s:");
	scanf("%f", &s);



	printf("");
	if (num > 10)
	{
		printf("Compute s = s + 3 * (num + 3.14)\n");
		s = s + 3 * (num + 3.14);
	}

	else
	{
		printf("Compute s = s + num * (num - 3.14)\n");
		s = s + num * (num - 3.14);
	}

	printf("The result is %f\n", s);

	return;
}
