subroutine picards(x1,x2,f1,f2)
  implicit none
  real, intent(in)::x1,x2
  real,intent(out)::f1,f2
  f1=x1+(1.0/20)*(-2*(x1**3)-8*x1+4*x2+4)
  f2=x2+(-1.0/24)*(-4*x1+ x2**2 + 3*x2 +1)
end subroutine  picards
