subroutine backsubs(a,x,n)
implicit none
integer,intent(inout)::n
real, dimension(n,n+1), intent(inout) :: a 
real,dimension(n), intent(inout) :: x
integer::i,j
real :: flag

flag = 0
x(n) = a(n, n+1) / a(n, n)

  do i = n - 1, 1, -1
      do j = n, i + 1, -1
          flag = flag + (a(i, j) * x(j))
      end do
      x(i) = (a(i,n+1) - flag) / a(i, i)
      flag = 0
  end do

end subroutine backsubs
