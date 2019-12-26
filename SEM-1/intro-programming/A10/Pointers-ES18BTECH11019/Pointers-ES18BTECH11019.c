#include<stdio.h>
#include<string.h>
void swap(char *a,char *b){//Function to swap two characters
    char temp;
    temp=*a;
    *a=*b;
    *b=temp;
}
void rev(char *str){//Function to reverse a string
    int l=strlen(str);
    int s=0,e=l-1;
    while(s<e)  {//Swapping first and last characters in a string until they become equal
        swap(&str[s],&str[e]);
        s++;
        e--;
    }
}
int main(){
    char ch,str[11];//string length limit is 10
    while(1){
    int cnt=0;
    scanf("%c",&ch);//scanning each character so that scan total total string,
     while (ch!='\n') {//but print reverse of string only if string length is atmost 10.
        if(cnt<10) str[cnt]=ch;//stroing scanned character in string
        cnt += 1;
        scanf("%c",&ch);
        }
     
    if(cnt<=10 && cnt!=0){
    str[cnt]='\0';//termination character
    rev(str);
    printf("%s \n",str);
    break;
    }
    else printf("Invalid Input. Enter again!! \n");
    }
    return 0;
}