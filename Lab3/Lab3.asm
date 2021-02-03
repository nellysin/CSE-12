.data
   # Phrase to ask user input
   prompt: .asciiz "Enter the height of the pattern (must be greater than 0):\t"
	
   error: .asciiz "Invalid Entry!\n"
	
   space: .asciiz "\t"

.text

   main:	# see where loops start and end
		
      user_input:	# This is where the user will input the number
         # Tell user to input a number
         li $v0, 4		#load immediate by address of null-terminated string to
	 la $a0, prompt		#load address in the argument register in prompt
         syscall 		# system call the user requested
	
	 # Getting the user input
	 li $v0, 5		#entering a number, stored in v0
	 syscall
	
	 # store result in $t2
	 move $t2, $v0		#for the num_loop
		
	 #check if t2 is greater than 0
	 bgtz $t2, num_loop 	# if $t2 is <= 0 print error & back to user_input			
		
	 #function to print the error message
	 li $v0, 4		
	 la $a0, error
	 syscall
	 j user_input
		
	
   #create the i = 1 to start
   li $t0, 1		# starting number for num loop
   li $t1, 0xA		# new line
	
   # create a loop for printing the *astrisk and number for the pyramid 
   num_loop: NOP 

	 bgt $t0, $t2, program_exit	# for (i =1, i < user_input, i++) then exit program
		
	 li $v0, 1		# read integer
	 move $a0, $t0		# move $t0 to $a0
	 syscall
	
	 li $v0, 11		# read ascii for new line
	 move $a0, $t1		# move $t1 to $a0
	 syscall
	
	 addi $t0, $t0, 1	# increment t0 (i) by one
	 j num_loop		# jump back to num_loop
	
	 program_exit:		
	 li $v0, 10		# command for exiting the program
	 syscall
	
