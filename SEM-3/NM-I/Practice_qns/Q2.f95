program Q2
 implicit none
 real :: r,area
 REAL, PARAMETER :: Pi = 3.1415927
write(*,*)"Enter the radius to caluclate area"
read(*,*)r
area=Pi*r*r
write(*,*)"The area of Circle is ",area
end program Q2
