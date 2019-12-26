program main
    implicit none
    real::f,x,tol=1
    integer::i=1
    write(*,*)"Please Provide the initial guess"
    read(*,*)x
    do while(tol>=1e-6)
        call picard(x,f)
        tol=abs((f-x)/x)
        write(*,*)i,"X=",x,"f=",f
        i=i+1
        x=f
    end do
end program
