subroutine inverse(A,B)
    implicit none
    real,intent(in),dimension(2,2)::A
    real,intent(out),dimension(2,2)::B
    B=0
    B(1,1)=1*A(2,2)
    B(1,2)=-1*A(1,2)
    B(2,1)=-1*A(2,1)
    B(2,2)=1*A(1,1)
B=B/((A(1,1)*A(2,2))-(A(2,1)*A(1,2)))
end subroutine inverse