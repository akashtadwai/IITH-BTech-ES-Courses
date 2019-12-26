program main
implicit none
real :: num1, num2,sumOf,ProdOf
print*,"Enter num1 , num2"
read(*,*)num1,num2

call statistics(num1, num2, sumOf, ProdOf)

print*,"The sum of the two given numbers is ",sumOf
print*,"The product the two given numbers is ",ProdOf
end program main