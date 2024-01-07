

.global _start

_start:
	# take the size of the triangle: N
	jal x1, print_enter_size
	jal x1, take_N
	
	add s2, zero, a0	# s2 = N, save N in s2
	
	add t0, zero, zero	# i = 0 initialize the index of the outer for-loop.

	bge t0, s2, print_N_error	# if N > 0, enter the loop
	
outer_loop:	
	add t1, zero, zero	# j = 0 initialize the index of the inner-loop.
	bge t0, s2, exit	# i < N => enter the inner loop, else finish.
	beq zero, zero, inner_loop
	
inner_loop:
	# print asteriks
	la a0, asterisk	# prepare to print string  
	li a7, 4	# print *.
	ecall
	
	addi t1, t1, 1	# j++
	ble t1, t0, inner_loop	# if i <= j, continue inner loop
	
	# new line	
	la a0, next_line	# prepare to print string  
	li a7, 4	# print \n
	ecall
	
	addi t0, t0, 1	# i++
	beq zero, zero, outer_loop	# go to the beginning of the outer loop
	

take_N:
	li a0, 0	# File descriptor, 0 for STDIN
	li a7, 5	# System call code for read integer. The value will be in a0
	ecall
	
	jalr x0, 0(x1)	# leave take_N

print_enter_size:
	la a0, enter_size	# prepare to print string  
	li a7, 4		# print error for N
	ecall	
	
	jalr x0, 0(x1)	# get back

print_N_error:
	la a0, N_error	# prepare to print string  
	li a7, 4		# print error for N
	ecall
	
	beq zero, zero, exit	# after printing err, exit
	
exit:
	addi a7, zero, 93	#Exit process 
	addi a0, zero, 13
	ecall

	
# in the data section if you use .ascii put \0 at the end so that it does not continue to read other values.
# Other option is to use .string - no need for \0 at the end, write what you want.	
.data
N_error: .ascii "N must be at least 1 !\n\0"

asterisk: .ascii "* \0"

next_line: .ascii "\n\0"

enter_size: .string "enter size N: "

