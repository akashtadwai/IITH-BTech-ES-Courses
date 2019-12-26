program example
 implicit none
 integer :: a(2,2),b(2,2),c(2,2),i,j
 do i=1,2
   do j=1,2
     read(*,*)a(i,j)
   end do
 end do
 do i=1,2
   do j=1,2
     read(*,*)b(i,j)
   end do
 end do

    c=a+b
  write(*,*)c
end program example
