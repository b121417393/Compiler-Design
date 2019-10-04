#include<stdio.h>

int main()
{
	int input=0,count=0,pass=0,max=0,min=100;
	float avg=0.1,sum=0.0;
	char i,j;

	
	while(i != 1){
		if( input>=0 ){
			count++;
			sum+=input;
			if(input>=60)
				pass++;
			else
				max=input;
		}
		else{
			count--;
			sum-=input;
		}
	}

	while(j<-1){
		count--;
		sum-=input;
		}

	for (i=1; i<10; i++)
	{
		j=(i*4+2-3)%2;
		j=j>>1;
		j=j<<1;
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
	printf("ya\n!");
	
	return 0;		
}
