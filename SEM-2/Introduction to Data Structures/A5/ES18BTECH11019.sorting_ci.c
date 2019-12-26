#include<stdio.h>
#define RANGE 1000

int max(int A[],int p){//Function for finding max of an array
int max=A[0];
for(int i=0;i<p;i++)
if(A[i]>max)
max=A[i];
return max;
}

int Found(int A[], int n, int key){//Linear search
  for(int i=0;i<n;i++)
    if(A[i]==key)
    return 1;
  return 0;
}

int main(){
  int A[RANGE]={-1},p=0;
  for(int i=0;i<RANGE;i++){
    int input;
    scanf("%d",&input);
    if(input>RANGE)//Given condition
    break;
    else{
    int k=Found(A,RANGE,input);//If element is found before then we should stop
  if(k==1)
    break;
  else{
    A[i]=input;
    p++;//No. of elements present in A before exit is p
  }
}
}
int max_of_arr=max(A,p);
int B[max_of_arr+1];//No. of elements in the array B will be (max.element in A[]+1)
for(int j=0;j<max_of_arr+1;j++){
  int count=0;
  for(int k=0;k<p;k++){//valid elements in array A are up to 'p'
    if(A[k]<=j){
      count++;
    }
  }
    B[j]=count;
}

for(int i=0;i<max_of_arr+1;i++)
printf("%d ",B[i]);
printf("\n");
int C[RANGE];
int q=0;
  for(int j=0;j<RANGE;j++){//We maintain the track of indices of array B, if the adjacent elements
      if(q<=RANGE){//are not same it means that an extra element is added to the array we print the
  if(B[j]!=B[j+1])// higher index of the array
    C[q++]=j+1;
}
}
for(int i=0;i<p;i++)
printf("%d ",C[i]);
}
