program simpson
      real::z,res
      integer::n=5
      real,dimension(5)::theta,thb,r
      z=0.5
      r(1)=0.0
      do i=2,n
        r(i)=r(i-1)+0.25
      end do
      do i=1,n
      call val(z,r(i),theta(i))
      call thetab(theta(i),r(i),thb(i))
      end do
      res=(thb(1)+4*thb(2)+2*thb(3)+4*thb(4)+thb(5))*(0.25/3.0)
      write(*,*)res
    end program simpson
    