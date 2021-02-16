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
      
      move $t0, a0              # moving $a0 to $t0 as temporary
      
      li $v0, 11
      la $a0, 0xA               # this is for visual
      
      li $t1, 0                 # this is the counter for num of characters
      
      move_char: NOP             # loop to check characters
      
         first_char:                             # check the first character of the name
            lb $a0, ($0)                         # load byte to the first character
            blt $a0, 'A', first_lower            # check if it is less than A try lower case
            ble $a0, 'Z', valid_char             # check if it is less than Z
         
         first_lower:                            # first character to check the lower case
            blt $a0, 'a', print_error            # if it is less than a then print an error
            bgt $a0, 'z', print_error            # if it is larger than z then print an error
         
         valid_char: NOP                         # check if the name is valid
            bgt $t1, 20 print_error              # if the coutner is greater than 20 print error
            lb $a0, ($t0)                        # load byte to the first character
            beqz $a0, program_exit
            li $v0, 11
            
            loop_upper: NOP
            blt $a0, 'A', loop_lower
            ble $a0, 'Z', next_char
            
            loop_num: NOP
            blt $a0, '0', loop_dot
            ble $a0, '9', next_char
            
            loop_dot: NOP
            bne $a0, '.', loop_under
               j next_char
            
            loop_under: NOP
            bne $a0, '_', program_exit
               j next_char
      
         next_char:
            addi $t1, $t1, 1                 # move to the next character
            addi $t0, $t0, 1
            syscall
            
            j valid_char
   
   print_error:
      li $v0, 4
      la $a0, error
      syscall
   
   program_exit:
      li $v0, 10
      syscall
