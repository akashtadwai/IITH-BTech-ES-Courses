subroutine requirment(x,y,n,a,b,c,d)
implicit none
integer::n,i
real,dimension(n),intent(in) ::x,y
real,intent(out) :: a,b,c,d
do i=1,n
    a=a+x(i)
    b=b+y(i)
    c=c+(x(i)*y(i))
    d=d+x(i)**2
end do

end subroutine requirment