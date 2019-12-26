#include<stdio.h>
#include<stdlib.h>
#include<time.h>
long fib(int n){
  if(n<1)//checking for valid value of "n"
  return -1;
  long f1=0,f2=1,fnext,i;
if(n==1)
return 0;
if(n==2)
return 1;
for(i=2;i<=n;i++){//iterative method
    fnext=f1+f2;//caluclating the next term
    f1=f2;//changing the values such that f1&f2 such that
    f2=fnext;//they shift to to their adjacent values
  }
  return f1;//After executing the loop for n-1 times
}            // we return the value of nth Fib. number.
int main(){
  int t;//No. of test cases
  scanf("%d",&t);//'t' should be greater than or equal to 1
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
