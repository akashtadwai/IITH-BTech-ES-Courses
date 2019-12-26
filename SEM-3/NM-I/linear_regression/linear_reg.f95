program linear_reg
    implicit none
    real::a=0.0,b=0.0,c=0.0,d=0.0,a0,a1
    integer::i,n=7
    real,dimension(7)::x,y
    open(10,file="data.txt")
    do i=1,n
    read(10,*)x(i),y(i)
end do
    call requirment(x,y,n,a,b,c,d)
    !write(*,*)"a=",a,"b=",b,"c=",c,"d=",d
    a1=(n*c-(a*b))/(n*d - a**2)
    a0=(-1.0/n)*(a1*a - b)
    write(*,*)"y=",a0,"+",a1,"x"
end program linear_reg
