program summation
implicit none
integer :: n=1,nfact=1
do while(n<=5)
nfact = nfact * n
n=n+1
write(*,*) n, nfact
end do
end program
