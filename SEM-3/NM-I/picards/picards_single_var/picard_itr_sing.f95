subroutine picard(x,f)
    implicit none
    real,intent(inout)::x,f
    f = exp(x)*(1.0/3.0)
end subroutine picard