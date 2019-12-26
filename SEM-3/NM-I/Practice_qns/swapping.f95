!gfortran -o a swapping.f95 swap.f95

subroutine swapping(a,b)
  implicit none
  real,intent(inout) :: a,b
  real :: temp
  temp=a
  a=b
  b=temp
end subroutine swapping
