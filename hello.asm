
.global _start
_start:

# ***************** STRING I/O ***********************
        la a0, helloworld	# prepare to print string  
        li a7, 4		# print string
        ecall
 
        li a0, 0      # File descriptor, 0 for STDIN
        la a1, str1   # Address of buffer to store string
        li a2, 255    # Maximum number of chars to store
        li a7, 63     # System call code for read string
        ecall

        la a0, str1	# prepare to print string 
        li a7, 4	# print string
        ecall
        
# ****************** INTEGER I/O **********************

        li a0, 0    # File descriptor, 0 for STDIN
        li a7, 5    # System call code for read integer. The value will be in a0
        ecall
        	
        #li a0, 43
        addi a0, a0, 1 # add +1 to the taken value (just to see how to manipulate the taken value.)
        li a7, 1	# Print integer. (the value is taken from a0)
        ecall
            
        addi a7, zero, 93     #Exit process 
        addi a0, zero, 13
        ecall 
.data	
helloworld: 
	.ascii "Merhaba\n"

str1:
	.space 255
	
	
	