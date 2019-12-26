program Q6
 implicit none
 integer :: n
 integer :: fib(1000)
 integer :: i
 write(*,*)"Input the nth fibonacci number that should be printed"
 read(*,*)n
 fib(1)=0
 fib(2)=1
 do i = 3,n
   fib(i)=fib(i-1)+fib(i-2)
 end do
 write(*,*)"The ",n,"fibonacci number is ",fib(n)
end program Q6
