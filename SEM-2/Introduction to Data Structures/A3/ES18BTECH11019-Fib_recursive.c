#include<stdio.h>
#include<stdlib.h>
#include<time.h>
long fib(int n){
  if(n<1)//checking for valid value of "n"
  return -1;
 if(n==1)//base cases for recursion
 return 0;
 if(n==2)
 return 1;
 return fib(n-1)+fib(n-2);//Recursive call by defintion of Fibonacci sequence
}
int main(){
  int t;//No. of test cases
  scanf("%d",&t);//'t' should be greater than than or equal to 1
  while(t--){
  int n;
  scanf("%d",&n);//scanning Input
  clock_t start,end;
  start=clock();//start of the timer
long k=fib(n);
end=clock();//end of the timer
double t=(end-start);
t=t/CLOCKS_PER_SEC;
if(k==-1)
printf("Invalid Input\n");//checking for valid value of input
printf("%lf is the time taken.",t);
if(k>=0)
printf("\nThe %d Fibonacci number is %ld",n,k);
}
}
