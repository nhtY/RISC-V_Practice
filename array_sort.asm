
.global _start

_start:
	jal x1, print_enter_size
	jal x1, take_N	# num of elements in a0
	
	add s2, zero, a0	# s2 = N : save a0 in s2
	add t0, zero, s2	# t0 = N, for current address
	slli t0, t0, 3	# N*8 bytes for N integers
	
	sub sp, sp, t0	# N*8 space for N elements
	
	add t0, zero, s2	# t0 = N
	add s3, zero, sp	# save last adress in s3, when reaching the elements use this one
	add t2, zero, s3	# t2 = sp, last address
	
	addi t6, zero, 1
	
get_integer:
	ble s2, zero, print_error	# N must be > 0
	# take the input
	jal x1, put_number
	jal x1, put_colon
	
	li a0, 0	# File descriptor, 0 for STDIN
	li a7, 5	# System call code for read integer. The value will be in a0
	ecall
	
	addi t0, t0, -1	# t1 = N-- : index
	add t1, zero, t0	# t2 = N-- 
	slli t1, t1, 3	# t2 = (N--)*8
	add t2, t2, t1	# save address
	
	sd a0, 0(t2)	# save taken int
	
	add t2, zero, s3	# t2 = sp, last element's address
	
	# continue till the temp index is < 0
	addi t6, t6, 1	# order number ++
	bgt t0, zero, get_integer
	
	
	add t2, zero, s3	# t2 = sp, last element's address
	addi t1, zero, 1	# i=1 start index
	
insertion_sort:
	beq t1, s2, loop_out	# get out of the for-loop
	
	add t0, zero, zero	# preapare t0
	
	# prepare data address
	sub t0, s2, t1	# N - i
	addi t0, t0, -1	# N - i - 1
	slli t0, t0, 3	# (N-i-1) * 8
	add t2, t2, t0	# last + (N-i-1) * 8
	
	# load data from the address
	ld a0, 0(t2)	# arr[i] = key: a0
	add t2, zero, s3	# t2 = sp, last address
	
	addi t3, t1, -1	# j = i - 1

# while( j>=0 and arr[j] > key)
while:	
	blt t3, zero, locate_key # j>=0 ??
	
	sub t0, s2, t3	# N - j
	addi t0, t0, -1	# N - j - 1
	slli t0, t0, 3	# (N-j-1) * 8
	add t2, t2, t0	# last + (N-j-1) * 8
	
	ld a1, 0(t2)	# arr[j] : a1
	add t2, zero, s3	# t2 = sp, last address
	
	blt a1, a0, locate_key	#  arr[j] > key ??
	# prepare data address
	addi t3, t3, 1	# j+1
	sub t0, s2, t3	# N - (j+1)
	addi t0, t0, -1	# -1
	slli t0, t0, 3	# 8* (N - (j+1))
	add t2, t2, t0	# address of arr[j+1]
	
	# save data
	sd a1, 0(t2)	# arr[j+1] = arr[j]
	add t2, zero, s3	# t2 = sp, last address
	
	addi t3, t3, -1	# j = (j + 1) -1 (because it was incremented)
	addi t3, t3, -1	# j = j - 1 : decrement j by 1
	
	beq zero, zero, while
	
# insert the key element into the proper location	
locate_key:
	# prepare data address
	addi t3, t3, 1	# j+1
	sub t0, s2, t3	# N - (j+1)
	addi t0, t0, -1
	slli t0, t0, 3	# 8* (N - (j+1))
	add t2, t2, t0	# address of arr[j+1]
	
	# save data
	sd a0, 0(t2)	# arr[j+1] = key
	add t2, zero, s3	# t2 = sp, last address
	
	addi t1, t1, 1	# i++
	
	beq zero, zero, insertion_sort
	
# when getting out of the insertion sort-loop	
loop_out:	
	add t0, zero, s2	# t0 = N
	add t2, zero, s3	# t2 = sp, last address
	jal x1, print_str_sorted	# print "Sorted array is: "

# iterate through the elements of the sorted array and print them	
print_array:
	# prapare the address of the data
	addi t0, t0, -1	# t1 = N-- : index
	add t1, zero, t0	# t2 = N-- 
	slli t1, t1, 3	# t2 = (N--)*8
	add t2, t2, t1	# load address
	
	# load data to be printed
	ld a0, 0(t2)	# load int
	
	add t2, zero, s3	# t2 = sp, last address
	
	li a7, 1	# print current element
	ecall
	
	jal x1, put_space	# print white space between the elements
	
	# continue till the temp index is < 0
	bgt t0, zero, print_array
					
	beq zero, zero, exit # finished..

take_N:
	li a0, 0	# File descriptor, 0 for STDIN
	li a7, 5	# System call code for read integer. The value will be in a0
	ecall
	
	jalr x0, 0(x1)	# leave take_N
	
print_new_line:
	la a0, new_line	# prepare to print string  
	li a7, 4	# print string
	ecall
	
	jalr x0, 0(x1)

print_enter_size:
	la, a0, enter_size
	li a7, 4
	ecall
	
	jalr x0, 0(x1)

print_str_sorted:
	la, a0, sorted
	li a7, 4
	ecall
	
	jalr x0, 0(x1)

put_space:
	la, a0, space
	li a7, 4
	ecall
	
	jalr x0, 0(x1)
	
put_number:
	addi a0, t6, 0
	li a7, 1	# print the order num for taken input
	ecall
	
	jalr x0, 0(x1)	
	
put_colon:
	la, a0, colon
	li a7, 4
	ecall
	
	jalr x0, 0(x1)
	
print_error:
	la, a0, error_N
	li a7, 4
	ecall
	
	beq zero, zero, exit
		
exit:
	addi a7, zero, 93	#Exit process 
	addi a0, zero, 13
	ecall
	
.data
space: .string " "

new_line: .string "\n"

error_N: .string "N must be at least 1 !\n"

colon: .string ": "

sorted: .string "Your sorted array is: "

enter_size: .string "Size of the array?: "
