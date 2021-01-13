addu    $t0, $t1, $t2   # $t0 = $t1 + $t2 
sub     $s0, $s0, $t4   # $s0 = $s0 - $t4
addi    $t0, $t2, 4     # $t0 = $t2 + 4	    
ori     $t0, $t0, 0x000000ff    # Set rightmost 8 bits to 1
andi    $t0, $t0, 0xffff0000    # Clear rightmost 16 bits