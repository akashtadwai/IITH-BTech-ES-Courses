subroutine req(y,x,xn,yn)
implicit none
real,intent(inout)::xn,yn
real,dimension(4),intent(inout)::x,y
real,dimension(3)::dy
real,dimension(2)::d2y
real,dimension(1)::d3y
real::a
a=(xn-x(1))/x(2)-x(1)
call del(y,dy,d2y,d3y)
yn=y(1)+a*dy(1)+((a*(a-1)*d2y(1))/2) + (a*(a-1)*(a-2)*d3y(1))/6
end subroutine req
