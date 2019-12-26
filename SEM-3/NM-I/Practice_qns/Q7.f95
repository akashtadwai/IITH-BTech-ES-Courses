program Q7
 implicit none
  integer :: i,num,flag=0
 write (*,*) 'what is the number to check?'
 read (*,*) num
 if (num .lt. 2) then
 write (*,*) 'Not a Prime number'
 endif
 do i = 2,(num-1)
 if(mod(num,i) .eq. 0) then
   flag=1
 end if
end do
if(flag==0) then
  write(*,*)"Prime Number!"
else
  write(*,*)"Not a prime"
endif
end program
