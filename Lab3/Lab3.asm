.data
   # Phrase to ask user input
   prompt: .asciiz "Enter the height of the pattern (must be greater than 0):\t"
	
   error: .asciiz "Invalid Entry!\n"
	
   space: .asciiz "\t"

.text

   main:	# see where loops start and end
		
      user_input: NOP	# This is where the user will input the number
         # Tell user to input a number
         li $v0, 4		#load immediate by address of null-terminated string to
	 la $a0, prompt		#load address in the argument register in prompt
         syscall 		# system call the user requested
	
	 # Getting the user input
	 li $v0, 5		#entering a number, stored in v0
	 syscall
	
	 # store result in $t2
	 move $t2, $v0		#for first loop as a max number
		
	 #check if t2 is greater than 0
	 bgtz $t2, first_loop 	# if $t2 is <= 0 print error & back to user_input			
		
	 #function to print the error message
	 li $v0, 4		
	 la $a0, error
	 syscall
	 
	 j user_input
		
	
   #create the i = 1 to start
   li $t0, 1		# starting number for num loop
   li $t1, 0xA		# new line
   
   
   # create a loop for printing the number for the pyramid 
   first_loop: NOP 
      bgt $t0, $t2, program_exit      # for (i =1, i < user_input, i++) then exit program
	
      li $v0, 1            # read integer
      move $a0, $t0      # move $t0 to $a0
      syscall             #execute the syscall
      
      li $v0, 11         # read ASCII
      la $a0, 0xA         # make a new line
      syscall            # execute in making a new line
      
      addi $t0, $t0, 1	# increment t0 (i) by one
      
      li $t3, 1
      # create a loop for adding the asterisks 
      second_loop: NOP
      bgt $t3, $t0, first_loop      #if t3 > t0 go back to first_loop
      
      li $v0, 11                     # print a ascii 
      la $a0, 0x2A                   # print an asterisk
      syscall                        # system call
      
      addi $t3, $t3, 1               # update the t3 counter 
      j second_loop                  # jump back to the second_loop
      
      program_exit:		
         li $v0, 10		# command for exiting the program
         syscall
      
      
      
      