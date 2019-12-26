program Q3
 implicit none
character(len=1) letter
integer :: a
write(*,*)"Enter the alphabet you want to know the ASCII value of"
read(*,*)letter
a=iachar(letter)
write(*,*)"The integer value of the character is ",a
end program Q3
