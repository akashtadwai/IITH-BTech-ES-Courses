program newton_raphson
  implicit none
  real::x=1.25,f,y,tol=1,u,df,f2
  do while(tol>=1e-6)
    f=x-exp(x)/3;
    call derivative(x,df)
    y=f/df
    u=x-y
    f2=u-exp(u)/3
    tol=abs((f2-f))
    write(*,*)"X=",u,"f=",f,"tol=",tol
    x=u
  end do
end program  newton_raphson
