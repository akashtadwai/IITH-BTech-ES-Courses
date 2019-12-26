program main
implicit none
real, dimension(3,4) :: a
real, dimension(3) :: x
a(1,1) = 2
a(1,2) = 1
a(1,3) = 0
a(1,4) = 1
a(2,1) = 1
a(2,2) = 2
a(2,3) = 1
a(2,4) = 2
a(3,1) = 0
a(3,2) = 1
a(3,3) = 1
a(3,4) = 4

call gauss(a,x,3)
print*,"The values of x are ",x
end program main