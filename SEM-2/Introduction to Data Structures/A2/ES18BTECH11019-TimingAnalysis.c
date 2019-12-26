#include<stdio.h>
#include<stdlib.h>
#include<time.h>
#define MAX 100000
int linear_search(int arr[], int n, int key){
  int i,count=0;
  for(i=0;i<n;i++){
    if(arr[i]==key)//searching element one by one and scanning the whole array
      count++;
  }
  return count;/*We should traverse the whole array and check the time for increasing the value of input n*/
}

int main(){
  int t;
  scanf("%d",&t);
  while(t--){
  long long int n;
  scanf("%lld",&n);
  printf("%lld",n);
  int arr[MAX];
  srand(time(0));//For generating distinct random numbers
  for(int i=0;i<n;i++)
    arr[i]=rand();
  int key=rand();
  clock_t start,end;
  start=clock();
  int k=linear_search(arr,n,key);
  end=clock();
  double t=(end-start);
  t=t/CLOCKS_PER_SEC;
  printf("\n%lf is the time taken.",t);
  }
}
