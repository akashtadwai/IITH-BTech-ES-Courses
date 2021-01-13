# This file is to testing error handling
add $s0,$s1,$s2
addi $t1, $t2, 100
beq $t1,$t2,error 
lw $1, 100($2