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
      
         first_char:
         lb $a0, ($t0)
         blt $a0, 'A', first_lower
         ble $a0, 'Z', valid_char
         
         first_lower: NOP
         blt $a0, 'a', program_exit
         bgt $a0, 'z', program_exit
         
         valid_char: NOP
   
   program_exit:
      li $v0, 10
      syscall
