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
   
   program_exit:
      li $v0, 10
      syscall
