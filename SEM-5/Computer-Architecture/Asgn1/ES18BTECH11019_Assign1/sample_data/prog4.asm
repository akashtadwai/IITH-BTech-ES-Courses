addi $t0, $zero, 2
j next
next:
j skip1
add $t0, $t2, $t3
skip1:
j skip2
add $t0, $t2, $t4
add $t0, $t2, $t0
skip2:
j skip3
loop:
add $t1, $t6, $t0
add $t7, $t0, $t0
add $t8, $t9, $t0
skip3:
j loop
