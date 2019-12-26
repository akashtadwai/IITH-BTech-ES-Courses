subroutine  val(z,r,theta)
    implicit none
    real,intent(inout)::z,r,theta
    theta=-4*z-r*r+(r**4/4.0)+(7.0/24.0)

    end subroutine val