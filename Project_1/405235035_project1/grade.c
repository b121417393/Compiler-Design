#include<stdio.h>


//test
/* test */
int main()
{
	int input=0,count=0,pass=0,max=0,min=100;
	float avg=0.1,sum=0.0;
	char i,j;
	char abc[100];
	
	while(scanf("%d",&input)!=EOF){
		if(input>=0 && input<=100 || input<=100){
			count++;
			sum+=input;
			if(input>=60)
				pass++;
			if(input>max)
				max=input;
			if(input<min)
				min=input;
		}
	}

	do
		j=0;
	while(j<-1);

	for (i=1; i<10; i++)
	{
		j=(i*4+2-3)%2;
		j=j>>1;
		j=j<<1;
		j=!j;
		j==j;
		j!=j;
	}

	if(count!=0)
		avg=sum/count;
	else
		avg=0;

	printf("Average: %.2f\n",avg);
	printf("Passed: %d\n",pass);
	printf("Max: %d\n",max);
	printf("Min: %d\n",min);
	
	return 0;		
}
