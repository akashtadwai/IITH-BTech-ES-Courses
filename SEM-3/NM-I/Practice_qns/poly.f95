program mainProgram
 implicit none
 integer::n=4,i,k=1,j,m
 real,dimension(5)::a,b,c
 real::tol=1,dr,ds,r,s,er,es
 do i=1,n+1
 read(*,*)a(i)
 read(*,*)r,s
 do i=1,10200,1
 b(n+1)=a(n+1)
 b(n)=a(n-1)+r*b(n)
 do j=1,n-1
    b(i)=a(j)+r*b(j+1)+s*b(j+2)
 end do
 c(n+1)=b(n+1)
 c(n)=b(n)+r*c(n-1)
  do m=1,n-1
    c(i)=b(m)+r*c(m+1)+s*c(m+2)
 end do
dr=(-b(2)*c(3) + b(1)*c(4)) / (c(3)**2 - c(2)*c(4))
ds=(-c(3)*b(1) + c(2)*b(2))/(c(3)**2 - c(2)*c(4))
r=r+dr 
s=s+ds
er=abs(dr/r)
    es=abs(ds/s)
    write(*,*)er,es
     if((es.le.tol).and.(er.le.tol))exit
     write(*,*)i
end do
end do
end program mainProgram
