program Q5
 implicit none
 real, parameter :: g = 9.8
 real, parameter :: pi = 3.1415927
 real :: a, t, u, x, y
 read(*,*) a, t, u
 a = a * pi / 180.0
 x = u * cos(a) * t
 y = u * sin(a) * t -0.5 * g * t * t
 write(*,*) " Horizontal position x : ",x
 if(y>0) then
 write(*,*) "Vertical position y:",y
else
  write(*,*)"Vertical position y: ",0
endif
end program Q5
