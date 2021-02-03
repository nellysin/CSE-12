.text
	# Tell user input to ender a number
	li $v0, 4		#load immediate by address of null-terminated string to
	la $a0, prompt		#load address in the argument register in prompt
	syscall 		# system call the user requested
	
	# Getting the user input
	li $v0, 5		#entering a number, stored in v0
	syscall
	
	# store result in $v0
	move $t2, $v0
	
	#create the i = 1 to start
	li $t1, 1
	
	# create a loop for printing the *astrix and number 
	num_loop: NOP 
	bge $t1, $t2, program_exit	# for (i =1, i < user_input, i++)
	li $v0, 1
	move $a0, $t1
	syscall
	
	li $v0, 11
	move $a0, $t1
	syscall
	
	addi $t0, $t0, 1
	j num_loop
	
	program_exit:
	li $v0, 10
	
.data
	prompt: .asciiz "Enter the height of the pattern (must be greater than 0):"
	# Phrase to ask user input
