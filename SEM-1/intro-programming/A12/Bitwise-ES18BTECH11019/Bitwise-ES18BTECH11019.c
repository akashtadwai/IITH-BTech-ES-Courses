/**Program to Compute Hamming Distance of two numbers*/
#include<stdio.h>

int Hammingdistance(int a,int b){
    int xorval=a^b,cnt=0; //No. of 1s in xor value of a and b represents the no. of different digits in binary representations 
    while(xorval){//counting no. of set bits in resulting xorvalue of a and b
        xorval&=xorval-1; //(n & (n-1)), we unset the rightmost set bit.
        cnt++;//If we do n & (n-1) in a loop and count the no of times loop executes we get the set bit count.
    }
    return cnt;
}
int main(void){
    int a,b;
    printf("Enter two numbers : ");
    scanf("%d %d",&a,&b);
    while(a<0 || b<0){
        printf("Please enter the Valid Positive Integers \n");
         printf("Enter two numbers : ");
        scanf("%d %d",&a,&b);
    }
    printf("\nThe Hamming distance is %d \n",  Hammingdistance(a,b));//printing the result.
    return 0;
}