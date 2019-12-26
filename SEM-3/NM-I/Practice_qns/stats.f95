subroutine statistics(num1,num2,sumOF,ProdOf)
implicit none
real, intent(in) :: num1, num2
real, intent(out) :: sumOf, ProdOf

sumOF = num1 + num2
ProdOf = num1 * num2

end subroutine statistics