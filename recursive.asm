
.global _start

_start:
	jal x1, print_enter_N
	jal x1, take_N	# num of elements in a0
	blt a0, zero, print_error	# print err and exit
	jal x1, funct	# call the function
	add s2, a0, zero	# move the result to s2
	jal x1, print_result	# print "result is: "
	addi a0 ,s2, 0	# move result to a0
	li a7, 1	# Print integer. (the value is taken from a0)
        	ecall
        	
        	beq zero, zero, exit	# finish.
	
	
	
funct:
	addi sp, sp, -16	# leave space for save operation
	sd x1, 8(sp)	# save return address
	sd a0, 16(sp)	# save return value and parameter
	#############
	bne a0, zero, L1	# if not base case, go to recursive part
	addi a0, zero, 5	# if x=0, prepare return 5
	addi sp, sp, 16	# pop the stack
	jalr x0, 0(x1)	# go to the previous method call --> upper level
	#############
L1:
	addi a0, a0, -1	# n - 1
	jal x1, funct	# method call with n-1
	addi t0, a0, 0	# t0 = result of f(n-1) 
	ld a0, 0(sp)	# restore caller's n
	ld x1, 8(sp)	# restore caller's return value
	addi a0, a0, 1	# now it is not the called method's parameter, now we are in one level upper method call
	addi sp, sp, 16	# pop the stack
	slli t0, t0, 1	# multiply returned value by 2
	add a0, a0, t0	# 2*f(n-1) + n
	jalr x0, 0(x1)
	
	

take_N:
	li a0, 0	# File descriptor, 0 for STDIN
	li a7, 5	# System call code for read integer. The value will be in a0
	ecall
	
	jalr x0, 0(x1)	# leave take_N
	
print_result:
	la, a0, result
	li a7, 4
	ecall
	
	jalr x0, 0(x1)

print_error:
	la, a0, error_N
	li a7, 4
	ecall
	
	beq zero, zero, exit
	
print_enter_N:
	la, a0, enter_N
	li a7, 4
	ecall
	
	jalr x0, 0(x1)	
						
exit:
	addi a7, zero, 93	#Exit process 
	addi a0, zero, 13
	ecall

.data
error_N: .string "N must be at least 0 !\n"

result: .string "result is: "

enter_N: .string "enter integer N (N >= 0): "
