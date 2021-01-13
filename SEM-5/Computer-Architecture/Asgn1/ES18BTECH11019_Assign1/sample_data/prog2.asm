L1: add  $t1, $t1, $t2  # (0) A[1] = A[1] + A[2]
    addi $t1, $t1, 2    # (1) A[1]+=2
    addi $t2, $t2, 2    # (2) A[2]+=2
    beq  $t1, $t2, L1   # (3) If A[1] == A[2] goto L1

# $t0=a, $t1=b, $t2=c;
bne $t0, $t1, Else     # if(a!=b) goto Else;
    addi $t2,$t3,1     # c  <-- 1+0
    j SkipElse         # goto SkipElse
Else: addi $t2,$t3,2       # c <-- 2+0
SkipElse:



