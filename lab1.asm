
.data
msg1: .asciiz "\n Programming Assigment 1 \n"
msg2: .asciiz ","
msg3: .asciiz "Before sorting:"
msg4: .asciiz "After sorting:"
msg5: .asciiz "\n"

.align 4
len:  .word 6
array:.word 33, 100, 5, 666, 99, 11

.text 					
.globl main
main:    
    li      $v0,4           # print msg3
    la      $a0,msg3        # address where msg3 is stored 	
    syscall	
    jal     printall        # print the array before sorting

# open Window->Console menu to see outputs.
# // Bobble sort in C. 
# for(int i = 1; i < n; i++) {
#     for(int j = 0; j < n - i; j++) {
#         if (v[j] > v[j+1])
#             swap(v, j);
#     }
# }	
    li      $v0,4           # print msg4
    la      $a0,msg4        # address where msg3 is stored 
    syscall	
                       
    la      $a0,array       # first parameter is v[] (address of the array)
    lw      $a1,len         # second parameter is n (length of the array)
    jal     sort            # jump to sort and save position to $ra

    jal     printall        # print the array after sorting

    li      $v0,10          # code for syscall: exit
	syscall                 # The program exits here! 


# =============== Your code starts here ============
sort:
	addi $sp, $sp, -20		#make room on stack for 5 registers
	sw $ra,16($sp)			#save $ra on stack
	sw $s3,12($sp)			#save $s3 on stack
	sw $s2,8($sp)			#save $s2 on stack
	sw $s1,4($sp)			#save $s1 on stack
	sw $s0,0($sp)			#save $s0 on stack
	
	move $s2, $a0			#copy parameter $a0 into $s2 (save $a0)
	move $s3, $a1			#copy parameter $a1 into $s3 (save $a1)
	
	move $0, $zero			#i = 0
	li $s0,1				#$s0 set equal to 1

for1tst:
	slt $t0,$s0,$s3			#reg $t0 = 0 if $s0 >= $s3 (i>=n)
	beq $t0,$zero,exit1		#go to exit1 if $s0>=$a1 (i>=n)
	move $s1,$zero			#copies the value in $zero to $s1
	
for2tst:
	
	sub $t0,$s3,$s0			#$t0 = n - 1
	beq $s1,$t0,exit3		#go to exit3 if j<=n
	sll $t1, $s1, 2			#reg $t1 = j * 4
	add $t2, $s2, $t1		#reg $t2 = v + (j * 4)
	lw $t3, 0($t2)			#reg $t3 = v[j]
	lw $t4, 4($t2)			#reg $t4 = v[j + 1]
	slt $t0, $t4, $t3	    #reg $t0 = 0 if $t4 >= $t3 
	beq $t0, $zero, exit2	#go to exit2 if $t4 >= $t3 					
	move $a0, $s2			#1st parameter of swap is v(old $a0)
	move $a1, $s1			#2nd parameter of swap is j
	jal swap				#swap code
	
	exit3:
	addi $s0, $s0, 1		#j += 1
	j for1tst				#jump to test of outer loop
	
	exit2:
	addi $s1, $s1, 1		#i += 1
	j for2tst				#jump to test of inner loop
	
	exit1:
	lw $s0,0($sp)			#restore $so from stack
	lw $s1,4($sp)			#restore $s1 from stack
	lw $s2,8($sp)			#restore $s2 from stack
	lw $s3,12($sp)			#restore $s3 from stack
	lw $ra,16($sp)			#restore $ra from stack
	addi $sp, $sp, 20		#restore stack pointer
	
	jr $ra					#restore to calling function
	
	

swap : 
	sll $t7, $a1, 2			#reg $t7 = k * 4
	add $t7, $a0, $t7		#reg $t7 = v + (k * 4)
							#reg $t7 has the address of v[k]
	lw $t8,0($t7)			#reg $t8 (temp) =v[k]
	lw $t9,4($t7)			#reg $t9 = v[k + 1]
							#refers to the next element of v
	sw $t9,0($t7)			#v[k] = reg $t9
	sw $t8,4($t7)			#v[k + 1] = reg $t8 (temp)

	jr $ra					#return to calling routine



# ================ Your code ends  here ==================
    
# ** expected output **
# Before sorting:
# 33,100,5,666,99,11,
# After sorting:
# 5,11,33,99,100,666,
    


# ================ Print Array Function ====================
printall:
    la      $t0,array
    ld      $t1,len         
    add     $t4,$zero,$zero
    li      $v0,4           # system call to print the string
    la      $a0,msg5
    syscall
imprime:
    li      $v0,1           # system call to print integer
    lw      $a0,0($t0)
    syscall
    li      $v0,4           # system call to print ","
    la      $a0,msg2
    syscall		
    addi    $t4,1
    addi    $t0,4
    bne     $t4,$t1,imprime
    li      $v0,4           # change line
    la      $a0,msg5
    syscall
    jr      $ra             # return to calling routine   
