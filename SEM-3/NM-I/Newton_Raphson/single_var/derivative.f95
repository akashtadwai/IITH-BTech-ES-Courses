subroutine derivative(x,df)
    implicit none
    real, intent(inout)::x
    real,intent(out)::df
    df=1-(exp(x)/3);
  end subroutine  derivative