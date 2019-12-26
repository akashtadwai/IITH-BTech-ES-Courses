#include<stdio.h>
typedef struct eparts {
    char s_no[4];
    int dd;
    int mm;
    int yy;
    char material[6];
    int weight;
} eparts;

void details(eparts* ptr) {
    printf("Serial number: %s \n",ptr->s_no);
    printf("Date of manufacture : %d-%d-%d \n",ptr->dd,ptr->mm,ptr->yy);
    printf("Material : %s \n",ptr->material);
    printf("Weight : %d \n",ptr->weight);
}

void list_weights(eparts* ptr,int parts) {
    int flag=0;
    printf("Serial numbers where weight is more than 5kg : ");
    for(int i=0; i<parts; i++) {
        if((ptr->weight)>5) { //checking for given condition
            flag=1;
            printf("%s ", ptr->s_no);
        }
        ptr++;
    }
    if(flag==0) printf("No entries found! \n");
}
void list_year(eparts* ptr,int parts) {
    int flag=0;
    printf("Year of manufacture of engine parts having serial number between AA2 and BB7 :");
    for(int i=0; i<parts; i++) {
        if((((ptr->s_no)[0])=='A' && ((ptr->s_no)[2]-'0')>=2) || (((ptr->s_no)[0])=='B' && ((ptr->s_no)[2]-'0')<=7)) {
            printf("%d ",(ptr->yy)); // Checking for valid condition
            flag=1;
        }
        ptr++;//incrementing pointer
    }
    if(flag==0) printf("No entries found!");
    printf("\n");
}

void print_details(eparts* ptr,int parts) {
    int flag=0;
    printf("Details of engine parts where year of manufacture is within 3 years of 15th Nov 2019 :\n");
    for(int i=0; i<parts; i++) {
        if((ptr->yy)>2016 && (ptr->yy)<=2019) { //Checking whether year of manufacture year is below 15th Nov 2019
            if((ptr->yy)==2019) {//if its 2019 then check other valid conditions
                if((ptr->mm)<11){
                    flag=1;
                     details(ptr);
                }
                else {
                    if((ptr->mm)==11 && (ptr->dd)<=15){
                            flag=1;
                            details(ptr);//print all details
                    }
                        
                }
            }
            else{
                flag=1;
                details(ptr);
            } 
        }
        else if((ptr->yy)==2016) { //else if year is 2016 then check other conditions
            if((ptr->mm)>11){
                flag=1;
                details(ptr);
            }    
            else {
                if((ptr->mm)==11 && (ptr->dd)>=15){
                    details(ptr);
                    flag=1;
                }
                    
            }
        }
        ptr++;//incrementing pointers
        printf("\n");
    }
    if(flag==0) printf("No entries found! \n");
}

int main() {
    int parts,dd,mm,yy;
    printf("Enter the number of parts: ");
    scanf("%d",&parts);
    eparts arr[parts];
    for(int i=0; i<parts; i++) {
        char temp[20];
        printf("Enter serial number of part %d: ",i+1);
        scanf(" %s",arr[i].s_no);
        printf("\nEnter Date of manufacture of part %d: ",i+1);
        scanf("%d-%d-%d",&arr[i].dd,&arr[i].mm,&arr[i].yy);
        printf("\nEnter material of part %d: ",i+1);
        scanf("%s",arr[i].material);
        printf("\nEnter weight of part %d: ",i+1);
        scanf("%d",&arr[i].weight);
        printf("\n");
    }
    list_weights(arr,parts);
    list_year(arr,parts);
    print_details(arr,parts);
}