
program newton_inter
    implicit none
    integer::i,k=4
    real,dimension(4)::x,y
    real, dimension(3) :: xn,yn
    open(10,file="data.txt")
    do i=1,k
    read(10,*)x(i),y(i)
end do
close(10)
    xn(1)=1.5
    xn(2)=2.5
    xn(3)=3.5
do i = 1,3
call getvalues(x,y,xn(i),yn(i))
write(*,*)"y at x=",xn(i),"is",yn(i)
end do
end program newton_inter
