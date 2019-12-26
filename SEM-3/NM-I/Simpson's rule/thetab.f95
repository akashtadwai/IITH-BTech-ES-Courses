subroutine thetab(theta,r,thb)
    real,intent(inout):: theta,r,thb
    thb=4*theta*(1-r**2)*r
end subroutine thetab