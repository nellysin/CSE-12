.data

   prompt: .asciiz "You entered the file: \n"
   
   error: .asciiz "ERROR: Invalid program argument"
   
   buffer: .space 20
   
.text

   lw $a0, 8 ($a1)
   la $a0, buffer
   li $a1, 20
   move $t0, $a0

   
   li $v0, 4
   la $a0, prompt
   syscall
   
   la $a0, buffer
   move $a0, $t0
   li $v0, 4
   syscall
   
   program_exit:
      li $v0, 10
      syscall
