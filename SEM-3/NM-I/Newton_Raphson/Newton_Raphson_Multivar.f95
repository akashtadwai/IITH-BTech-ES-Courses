program newton_raphson__multi_var
  implicit none
  real::y3=0.5,y2=0.5,f1,f2,tol1=1,tol2=1,y2nex,y3nex
  real,dimension(2,2)::A,B
  do while(tol1>=1e-7 .and. tol2>=1e-7 )
    f1=4-8*y2+4*y3-2*(y2**3)
    f2=1-4*y2+3*y3+(y3**2)
    call derivative_multi_var(y3,y2,A)
    call inverse(A,B)
    y2nex=y2-(B(1,1)*f1+B(1,2)*f2)
    y3nex=y3-(B(2,1)*f1+B(2,2)*f2)
    tol1=abs(y2nex-y2)
    tol2=abs(y3nex-y3)
    write(*,*)"y2=",y2,"y3=",y3
    y2=y2nex
    y3=y3nex
  end do
end program  newton_raphson__multi_var
