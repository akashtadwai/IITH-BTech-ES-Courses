#This is a comment
#This tests all instructions
#in the mips subset we have taken
main:
    RType:
        add $t2,$zero,$t0
        addu $t6, $t4, $t5
        sub $t2,$t1,$t0
        subu $t6, $t4, $t5
        and $t2,$t1,$t0
        or $t6, $t4, $t5
        nor $t2,$t1,$t0
        slt $t6, $t4, $t5
        sltu $t2,$t1,$t0
        j IType
    IType: 
        add     $t2, $t1, $t0
        sub     $t3, $t1, $t0
        nor     $t6, $t4, $t5
        slt     $t7, $t4, $zero
        sll     $t8, $t7, 2
        srl     $t9, $t7, 2
        and     $t4, $t2, $t3
        or      $t5, $t2, $t3
        j RType
    jr      $ra
    beq     $t7, $t6, IType
    sw      $s0, -4($s3)
    sw      $s1, 4($s2)
    ori     $s4, $s1, 1
    andi    $s5, $s0, 1
    bne     $s4, $s5, Exit
    lw      $s0, 5($s2)
    lw      $s1, -5($s3)
    j Exit
Exit: