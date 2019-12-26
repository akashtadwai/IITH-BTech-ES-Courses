subroutine del(y,dy,d2y,d3y)
implicit none
real,intent(in),dimension(4)::y
real,intent(out),dimension(3)::dy
real,intent(out),dimension(2)::d2y
real,intent(out),dimension(1)::d3y
integer::i
do i=1,3
    dy(i)=y(i+1)-y(i)
end do
do i=1,2
    d2y(i)=dy(i+1)-dy(i)
end do
d3y(1)=d2y(2)-d2y(1)
end subroutine del
