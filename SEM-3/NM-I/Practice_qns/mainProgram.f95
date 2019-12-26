program mainProgram
 implicit none
 integer :: a,v(3,5),i,j
 real :: b
 complex :: c
 logical :: done
 character(len=5) :: name
 read (*,*)a,b,c,done,name
 write (*,*)'a =',a,'b=',b,'c=',c ,'done=',done,'name =',name
 do i=1,3
   do j=1,5
     read(*,*)v(i,j)
     write(*,*)v(i,j)
   end do
 end do
end program mainProgram
