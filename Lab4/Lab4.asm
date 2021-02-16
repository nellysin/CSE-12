.data

   prompt: .asciiz "You entered the file: \n"
   
   error: .asciiz "ERROR: Invalid program argument"
   
   buffer: .space 20
   
.text
   argument_input:
      li $v0, 4                 # syscall print string 
      la $a0, prompt            # print the prompt
      syscall
      
      lw $a0, 0($a1)            # get file name
      
      li $v0, 4                 # print the file name
      syscall
      
      move $t0, $a0              # moving $a0 to $t0 as temporary
      
      li $v0, 11
      la $a0, 0xA               # this is for visual
      
      li $t1, 0                 # this is the counter for num of characters
      
      move_char: NOP             # loop to check characters
      
         first_char:                             # check the first character of the name
            lb $a0, ($t0)                         # load byte to the first character
            blt $a0, 'A', first_lower            # check if it is less than A try lower case
            ble $a0, 'Z', valid_char             # check if it is less than Z
         
         first_lower:                            # first character to check the lower case
            blt $a0, 'a', print_error            # if it is less than a then print an error
            bgt $a0, 'z', print_error            # if it is larger than z then print an error
         
         valid_char: NOP                         # loop to check if the name is valid
            bgt $t1, 20 print_error              # if the coutner is greater than 20 print error
            lb $a0, ($t0)                        # load byte to the first character
            beqz $a0, program_exit               # if $a0 has no char then program_exit
            li $v0, 11                           # this is for visual (print character)
            
            loop_upper: NOP                      # loop to check char if it is A-Z
               blt $a0, 'A', loop_lower          # if $a0 is lower check lower case
               ble $a0, 'Z', next_char           # if $a0 is less than Z go to next char
            
            loop_num: NOP                        # loop for checking 0-9
               blt $a0, '0', loop_dot            # if less than 0 then try loop_dot
               ble $a0, '9', next_char           # if less than 9 go to next char
            
            loop_dot: NOP                        # loop for checking a period
               bne $a0, '.', loop_under          # if $a0 is not equal to a period try loop_under
                  j next_char                    # else go to the next character
            
            loop_under: NOP                      # loop for checking a underscore
               bne $a0, '_', print_error         # if $a0 is not equal to underscore print error
                  j next_char                    # else go to next character
      
            next_char:                           # this is going to the next character
            addi $t1, $t1, 1                     # increment the counter by 1
            addi $t0, $t0, 1                     # move to the next character  
            syscall                              # system call
            
            j valid_char                         # jump back to valid_char
   
   print_error:                                  # to print the error message
      li $v0, 4                                  # print a string
      la $a0, error                              # print the written error 
      syscall                                    # execute
   
   program_exit:                                 # to program exit 
      li $v0, 10                                 # syscall to exit the program
      syscall                                    # execute
