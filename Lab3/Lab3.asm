.data
   prompt: .asciiz "Enter the height of the pattern (must be greater than 0):\t"   # Phrase to ask user input
	
   error: .asciiz "Invalid Entry!\n"      # a message when number is <= 1

.text

   main:	# for me to see where loops start and end
		
      user_input: NOP	# This is where the user will input the number
      
         # Tell user to input a number
         li $v0, 4            #load immediate by address of null-terminated string to
	 la $a0, prompt      #load address in the argument register in prompt
         syscall              # system call the prompt
	
	 # Getting the user input
	 li $v0, 5            #entering a number, stored in v0
	 syscall             # system call $v0
	
	 # store result in $t2
	 move $t2, $v0        # copying $v0 to $t2 (will be used as max number)
		
	 #check if t2 is greater than 0
	 li $t0, 1             # $t0 will be our "i" or the counter for first_loop
	 bgtz $t2, first_loop    # if $t2 is <= 0 print error & back to user_input			
		
	 #function to print the error message
	 li $v0, 4            # syscall for reading the address
	 la $a0, error       # print out the error message
	 syscall              # system call to print the error message
	 
	 j user_input         # jump back to user_input to ask user_input again

      first_loop: NOP                # This loop is for the number and '*'
	 # create a loop for adding the asterisks 
	 beq $t0, 1, skip_loop            #if our counter ($t0) <= 1 go to skip_loop
	 
         second_loop: NOP                # this loop print the first set of *
            bge $t3, $t0, skip_loop      #if t3 >= t0 go to skip loop

            li $v0, 11                   # read an ascii 
            la $a0, 0x2A                 # print a '*'
            syscall                      # system call to print 
    
            li $v0, 11                   # read an ascii
            la $a0, 0xB                  # print a tab
            syscall                      # system call
            
            addi $t3, $t3, 1             # update the t3 counter 
            
            j second_loop                # jump back to the second_loop
         
	 skip_loop:
	    li $t3, 1
	    li $v0, 1            # read integer
            move $a0, $t0      # move $t0 to $a0
            syscall             #execute the syscall
            
            
            li $t3, 1
            beq $t0, 1, cont_skip_loop      #if $t0 <= 1 continue to skip loop
            third_loop: NOP                   # print the second asterisk set
               bge $t3, $t0, cont_skip_loop      #if t3 >= t0 continue skip_loop
               
               li $v0, 11                    # read an ascii
               la $a0, 0xB                   # print a tab
               syscall                       # system call
               
               li $v0, 11                     # print a ascii 
               la $a0, 0x2A                   # print an asterisk
               syscall                        # system call

               addi $t3, $t3, 1               # update the t3 counter 
               j third_loop                  # jump back to the third_loop
            
         cont_skip_loop:      # a continuation of skip_loop  
            li $v0, 11         # read ASCII
            la $a0, 0xA         # make a new line
            syscall            # execute in making a new line
            
            addi $t0, $t0, 1	# increment t0 (i) by one
            
            bgt $t0, $t2,  program_exit # for (i =1, i < user_input, i++) then exit program 
	    li $t3, 1
	    j first_loop 
	    
      program_exit:		
         li $v0, 10		# command for exiting the program
         syscall