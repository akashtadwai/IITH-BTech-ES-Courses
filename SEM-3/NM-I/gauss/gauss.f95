subroutine gauss(a,x,n)

implicit none
integer,intent(inout)::n
real,dimension(n,n+1),intent(inout):: a
real,dimension(n),intent(inout)::x
integer::i,j,k
real :: factor
do k = 1, n-1
        do i = k+1, n
            factor = a(i, k) / a(k, k)
            do j = k, n + 1
                a(i, j) = a(i, j) - (factor * a(k, j))
            end do
        end do
    end do
call backsubs(a,x,n)
end subroutine gauss
