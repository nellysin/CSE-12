.data
	prompt: .asciiz "Enter the height of the pattern (must be greater than 0):\t"
	# Phrase to ask user input
	
	asterisk: .asciiz "*"
	
	error: .asciiz "Invalid Entry!"
	
	space: .asciiz "\t"

.text
user_input:
	# Tell user to input a number
	li $v0, 4		#load immediate by address of null-terminated string to
	la $a0, prompt		#load address in the argument register in prompt
	syscall 		# system call the user requested
	
	# Getting the user input
	li $v0, 5		#entering a number, stored in v0
	syscall
	
	# store result in $t2
	move $t2, $v0		#for the num_loop
	
	#check if t2 is less than or equal to 2
#new_loop: NOP
	#blez $t2, exit_newloop
	#li $v0, 4
	#la $a0, error
	#syscall
	
	#li $v0, 4		#load immediate by address of null-terminated string to
	#la $a0, prompt		#load address in the argument register in prompt
	#syscall 		# system call the user requested

	# Getting the user input
	#li $v0, 5		#entering a number, stored in v0
	#syscall
		
	#j new_loop

	#exit_newloop:
	#li $v0, 10
	#syscall	
	
	#create the i = 1 to start
	li $t0, 1		# starting number
	li $t1, 0xa		# new line
	li $t3, 1
		

	# create a loop for printing the *astrix and number
num_loop: NOP 

	bgt $t0, $t2, program_exit	# for (i =1, i < user_input, i++)
	
	asterisk_loop: NOP 
		bgt $t1, $t3, add_asterisk
		
		add_asterisk:
		li $v0, 4
		la $a0, asterisk
		syscall
		
		
	li $v0, 1
	move $a0, $t0
	syscall
	
	li $v0, 11
	move $a0, $t1
	syscall
	
	addi $t0, $t0, 1
	j num_loop
	
	program_exit:
	li $v0, 10
	syscall
	
