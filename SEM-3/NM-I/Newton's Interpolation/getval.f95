subroutine getvalues(x, y, xn, yn)
implicit none
real, dimension(4), intent(in) :: x, y
real, intent(in) :: xn
real, intent(out) :: yn
real, dimension(3) :: dy
real, dimension(2) :: d2y
real,dimension(1)::d3y
real ::  a
call del(y,dy,d2y,d3y)
a = (xn - x(1))/(x(2) - x(1))
yn= y(1) + dy(1)*a + d2y(1)*(a**2-a)/2 + d3y(1)*((a**2 - a)*(a - 2))/6.0
end subroutine getvalues