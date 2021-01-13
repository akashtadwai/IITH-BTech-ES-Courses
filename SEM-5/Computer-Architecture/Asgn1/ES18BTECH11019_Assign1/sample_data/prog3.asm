    beq  $t1, $t2, L1   # (0) If A[1] == A[2] goto L1
    addi $t1, $t1, 1    # (1) A[1]++
    addi $t2, $t2, 1    # (2) A[2]++
L1: add  $t1, $t1, $t2  # (3) A[1] = A[1] + A[2]
