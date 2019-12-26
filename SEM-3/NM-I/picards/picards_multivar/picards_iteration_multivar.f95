program picards_iteration
  real::x1,x2,tol1=1,tol2=1
  read(*,*)x1,x2
  do while(tol1>=1e-6 .and. tol2>=1e-6 )
    call picards(x1,x2,f1,f2)
    tol1=abs((f1-x1)/x1)
    tol2=abs((f2-x2)/x2)
    write(*,*)"X1=",x1,"X2=",x2,"f1=",f1,"f2=",f2
    x1=f1
    x2=f2
  end do
end program
