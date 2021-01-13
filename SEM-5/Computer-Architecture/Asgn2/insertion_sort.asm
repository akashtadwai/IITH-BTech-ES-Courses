.data
arr:        .word 0:500 
arr1:	    .word 0:500
arr2:	    .word 0:500
size_input : .asciiz "Enter the number of elements in the array: "
first_ele:   .asciiz "Enter first element of the sequence: \n"
common_ratio:         .asciiz "Enter the common ratio of the sequence: \n"
msg_1:  .asciiz "Array after sorting in Ascending Order  is :"
msg_2: .asciiz "Original Array is : "
msg_3: .asciiz "No. of comparisions to sort the array is : "
msg_4: .asciiz"Array Sorted in Descending order is :"
msg_5: .asciiz "Array after randomising is : "

space:	.asciiz " "		# a space string.
line:	.asciiz	"\n"		# a newline string.
.text
.globl	main

main:

input:
	li $v0, 4		   # Setting $v0 to print the message
	la $a0, size_input     # Output message to input size of the list
	syscall

	li $v0, 5               # system call for keyboard input, we get the size of the list
	syscall
	move $s0, $v0    #s0 has input_size
	
	li $v0, 4		  
	la $a0, first_ele    
	syscall

	li $v0, 5  
	syscall
	move $s1,$v0     # Our first element is at $s1
	
	li $v0, 4		 
	la $a0, common_ratio    
	syscall

	li $v0, 5             
	syscall
	move $s2,$v0     # Our common ratio  is at $s2

# increasing array --> $s4 arr
# Dec --> $s5 arr_1
# Random --> $s6  arr_2	

gen_array:  # generating 3 arrays
	addi $s3, $0, 1 # $s3 = i
	la $s4,arr 
	la $s5,arr1
	la $s6,arr2
	sw $s1,0($s4)
	sw $s1,0($s5)
	sw $s1,0($s6)
   L1:  bge $s3,$s0 DONE
   	sll $t0, $s3, 2 # $t0=i * 4
   	add $t0, $t0, $s4  # addr of arr[i]
   	sll $t3, $s3, 2 # $t0=i * 4
   	add $t3, $t3, $s5  # addr of arr[i]
   	sll $t4, $s3, 2 # $t0=i * 4
   	add $t4, $t4, $s6  # addr of arr[i]
   	lw $t1, 0($t0) # $t=arr[i]
   	lw $t2,-4($t0) #t2=arr[i-1]
   	mul $t2,$t2,$s2   
   	sw $t2,0($t0)  
   	sw $t2, 0($t3)
   	sw $t2, 0($t4)  
   	addi $s3,$s3,1     
   	j L1 
   
   DONE:
   	li $v0,4
   	la $a0,msg_2
   	syscall 
   	move $a0,$s4      #printing original Ascending Array
   	jal print
   	
   	move $a0,$s4
   	move $a1,$s0   
   	jal insertion_sort    #printing Number of comparisions
   	move $s7,$v0
   	li $v0,4         
   	la $a0,msg_3
   	syscall 
   	li $v0,1
   	move $a0,$s7
   	syscall  
   	
        li	$v0, 4
	la	$a0, line
	syscall 
   	
   	
   	
   	move $a1,$s5
   	move $a2,$s0
   	jal reverse         # reversing the array
   	  
   	li $v0,4
   	la $a0,msg_4        # Printing the descending array
   	syscall 
   	move $a0,$s5
   	jal print
   	
   	move $a0,$s5
   	move $a1,$s0   
   	jal insertion_sort	#printing Number of comparisions
   	move $s7,$v0
   	li $v0,4
   	la $a0,msg_3
   	syscall 
   	li $v0,1
   	move $a0,$s7
   	syscall  
   	
   	  li	$v0, 4
	la	$a0, line
	syscall 
	
	
   	
   	
   	#move $a0,$s6
   	#jal print
   	
   	move $a2,$s6
   	move $a3,$s0
   	jal randomise	     #printing randomised array
   	
   	li $v0,4
   	la $a0,msg_5
   	syscall 
   	
   	move $a0,$s6
   	jal print  
   	
   
   	move $a0,$s6
   	move $a1,$s0   
   	jal insertion_sort		#printing Number of comparisions
   	move $s7,$v0
   	li $v0,1
   	li $v0,4
   	la $a0,msg_3
   	syscall 
   	li $v0,1
   	move $a0,$s7
   	syscall  
   	
   	j exit  
   	
   	
 
reverse:	# a1 -> arr, a2 -> n
	li $t0,0 #i=0
	addi $t1,$a2,-1 #t1=n-1
	srl $t2,$a2,1 #t2=n/2
	
	L: bge $t0,$t2,END
	sll $t3,$t0,2
	add $t3,$t3,$a1 #a[i] 
	lw $t4,0($t3)
	sll $t5,$t1,2
	add $t5,$t5,$a1 #a[n-i-1]
	lw  $t6,0($t5)
	
	addi $t7,$t4,0
	sw $t6,0($t3)
	sw $t7,0($t5)    #swap the contents 
	addi $t0,$t0,1   #i++
	subi $t1,$t1,1   #j--
	j L
	
	END:
	jr $ra
		

# Logic of insertion sort
# i ← 1
#cnt ← 0
# while i < length(A)
#     x ← A[i]	
#     j ← i - 1
#     while j >= 0 and ++cnt and A[j] > x
#         A[j+1] ← A[j]
#         j ← j - 1
#     end while
#     A[j+1] ← x
#     i ← i + 1
# end while

# Registers:
#   $a0: base address; $a1: N
#   $t0: i
#   $t1: j
#   $t2: value of A[i] or A[j]
#   $t3: value of x (current A[i])
#   $t4: current offset of A[i] or A[j] as needed
insertion_sort:
addi $sp, $sp, -4  #storing the $ra as we are calling nested procedures to print the sorted array
sw $ra, 0($sp)
# i ← 1
       li $t0, 1
       addi $t5,$0,0
      
# while i < N
            # test before 1st iteration
       j Wnext001  
       
         
Wbody001:                # body of loop here
      sll $t4, $t0, 2    # scale index i to offset
      add $t4, $a0, $t4  # address of a[i]
#     x ← A[i]
      lw $t3, 0($t4)
#     j ← i - 1
      addi $t1, $t0, -1
#     while j >= 0 and A[j] > x
       j Wnext002        # test before 1st iteration
Wbody002:                # body of loop here
#         A[j+1] ← A[j]
          sll  $t4, $t1, 2        # scale index j to offset
          add $t4, $a0, $t4       # address of a[j]
          lw $t2, 0($t4)          # get value of A[j]
          addi $t4, $t4, 4        # offset of A[j+1]
          sw $t2, 0($t4)          # assign to A[j+1]
#         j ← j - 1
          addi $t1, $t1, -1
#     end while

Wnext002: # construct condition, j >= 0 and A[j] > x
          blt $t1, $zero Wdone002 # convert to: if j < 0 break from loop #####
          sll  $t4, $t1, 2        # scale index j to offset
          add $t4, $a0, $t4       # address of a[j]
          lw $t2, 0($t4)          # A[j]
       	  addi $t5,$t5,1
       	  bgt $t2, $t3, Wbody002 # no need to test j >= 0, broke from loop already if false
          
Wdone002:                         # branch here to short-circuit and
#     A[j+1] ← x
          add  $t4, $t1, 1        # scale index j+1 to offset
          sll  $t4, $t4, 2        # scale index j to offset
          add $t4, $a0, $t4       # address of a[j+1]
          sw $t3, 0($t4)          # A[j+1] becomes x
#     i ← i + 1
          addi $t0, $t0, 1
# end while

Wnext001: blt $t0,$a1, Wbody001  # i < N
	   move $t7,$a0   
	  li $v0,4
	  la $a0,msg_1
	  syscall 
	  move $a0,$t7
          jal print
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        move $v0,$t5
          jr $ra 
	
	
# Fisher-Yates algorithm for randomisation	
#for (int i = n - 1; i > 0; i--)  {
#         // Pick a random index from 0 to i
#         int j = rand() % (i + 1);
#         // Swap arr[i] with the element
#         // at random index
#         swap(&arr[i], &arr[j]);
#     }
randomise:
#Registers
#a2->array
#a3->n
#t0->i=n-1	
	move $t0,$a3
	move $t3,$a3
	subi $t3,$t3,1
	subi $t0,$t0,1
  LOOP: ble $t0,$zero, EndLoop
  
  	li    $a1, 9       	 # Setting upper limit 
	li    $v0, 42          # Calling for random integer
 	syscall
    	
        add $t1, $a0, $zero
        addi $t2,$t0,1
        div $t1,$t2
        mfhi $t3
        
        #swap elements
        sll $t4,$t0,2
        sll $t5,$t3,2
        add $t4,$t4,$a2
        add $t5,$t5,$a2
        lw $t6,0($t5)
        lw $t7,0($t4)
        sw $t7,0($t5)
        sw $t6,0($t4) 
        subi $t0,$t0,1
   	j LOOP  
   	
   EndLoop: 
   	jr $ra 
      
# Function for printing a lop in neat order       
print:
print_loop_prep:
	
	move	$t7, $a0
	move $t8,$s0 
	li	$t9, 0
print_loop:
	bge	$t9, $t8, print_end
	li	$v0, 1
	lw	$a0, 0($t7)
	syscall
	li	$v0, 4
	la	$a0, space
	syscall
	addi	$t7, $t7, 4
	addi	$t9, $t9, 1
	j	print_loop
print_end:
	li	$v0, 4
	la	$a0, line
	syscall
	jr $ra 
	
	
# syscall to exit
exit:
	li	$v0, 10			# 10 = exit syscall.
	syscall				# issue a system call.
	
 
