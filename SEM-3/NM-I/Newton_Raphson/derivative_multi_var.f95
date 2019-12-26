subroutine derivative_multi_var(y3,y2,A)
    implicit none
    real, intent(inout)::y2,y3
    real,dimension(2,2),intent(out)::A
    A(1,1)=-8-6*(y2**2)
    A(1,2)=4
    A(2,1)=-4
    A(2,2)=3+(2*y3)
  end subroutine  derivative_multi_var
