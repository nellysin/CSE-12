#################################################################################################################### 
# Created by: Sin, Nelly                                                                                            #     
#              nesin                                                                                               #        
#             16, February, 2021                                                                                   #     
#                                                                                                                  #         
# Assignment: Lab4, Syntax Checker                                                                                 #           
#             CSE 12/ 12L, Computer Systems and Assembly Language                                                  #
#             UC Santa Cruz, Winter 2020                                                                           #            
#                                                                                                                  #           
# Description: This program opens a file. Within the file, it will find the unconnected brackets                   #
#                                                                                                                  #             
# Notes:        This program is intended to be run frm the MARS IDE                                                # 
####################################################################################################################

.data

   prompt: .asciiz "You entered the file:\n"
   
   error: .asciiz "\nERROR: Invalid program argument \n"
   
   mismatch: .asciiz "\nERROR - There is a brace mismatch:"
   mismatch_1: .asciiz " at index \n"
   
   stacked_braces: .asciiz "\nERROR - Braces(s) still on stack: "
   
   success: .asciiz "\nSUCCESS: There are" 
   success_1: .asciiz " of braces. \n"
   
   buffer: .space 128   # load each character from the content
   
   newLine: .asciiz "\n"
   
.text
   la $s1, ($sp)
   argument_input:
      li $v0, 4                 # syscall print string 
      la $a0, prompt            # print the prompt
      syscall                   # execute
      
      lw $a0, 0($a1)            # get file name
      move $s0, $a0             # save file name use later to open file
      li $v0, 4                 # print the file name
      syscall
      
      move $t0, $a0              # moving $a0 to $t0 as temporary
      
      la $a0, newLine               # ascii for new line
      syscall                   # execute
      
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
            bgt $t1, 20, print_error              # if the coutner is greater than 20 print error
            lb $a0, ($t0)                        # load byte to the first character
            beqz $a0, open_file                  # if $a0 has no char then program_exit
            #li $v0, 11                           # this is for visual (print character)
            
            loop_upper: NOP                      # check if $a0 is A-Z
               blt $a0, 'A', loop_lower          # if $a0 is lower check lower case
               ble $a0, 'Z', next_char           # if $a0 is less than Z go to next char
               
            loop_lower: NOP                      # check if $a0 is a-z
               blt $a0, 'a', loop_num            # if $a0 is less than a then try loop_num
               ble $a0, 'z', next_char           # if $a0 is less than or equal to 9 go next char
            
            loop_num: NOP                        # loop for checking 0-9
               blt $a0, '0', loop_dot            # if less than 0 then try loop_dot
               ble $a0, '9', next_char           # if less or equal than 9 go to next char
            
            loop_dot: NOP                        # loop for checking a period
               bne $a0, '.', loop_under          # if $a0 is not equal to a period try loop_under
                  j next_char                    # else go to the next character
            
            loop_under: NOP                      # loop for checking a underscore
               bne $a0, '_', print_error         # if $a0 is not equal to underscore print error
                  j next_char                    # else go to next character
      
            next_char:                           # this is going to the next character
            addi $t1, $t1, 1                     # increment the counter by 1
            addi $t0, $t0, 1                     # move to the next character  
            #syscall                             # system call (this is for printing visual)
            
            j valid_char                         # jump back to valid_char
            
    print_error:                                 # to print the error message
      li $v0, 4                                  # print a string
      la $a0, error                              # print the written error 
      syscall                                    # execute
     
      j program_exit
   
   file:                                            # rules of opening, reading, and closing the file
      open_file:                                    # opening the file given by file name
         li $v0, 13                                 # syscall for opening the file
         la $a0, ($s0)                              # get the file name
         li $a1, 0                                  # open for reading (0)                  
         syscall                                    # execute open file
         move $s0, $v0                              # save contents from $v0 to $s0
      
      read_file:                                    # reading file
         li $v0, 14                                 # sysall for reading the file
         move $a0, $s0                              # get the saved file name
         la $a1, buffer                             # this buffer will hold the content in the file
         la $a2, 128                                # how much to take in 
         syscall                                    # execute the read_file
         
         
      stacking: NOP                                 # stacking brackets from file text
         li $t4, 0                                  # pair count
         load_byte: NOP                               # loads each byte from the text
            la $a0, buffer                             # this stores the content from the file
            lb $a0, buffer ($t3)                       # load each value in $a0 by $t3
            li $v0, 11
            syscall
            
            check_bracket: NOP                            # where the pointer is, count each bracket (if its a "(", "}", "]")
               beqz $a0, check_stack                    # if $a0 = 0 then close file        
               
               left_parenth: NOP
                  bne $a0, '(', right_parenth              # if the pointer != '(', try left_parenth
                     push_parenth:                         # save it to the stack
                        addi $sp, $sp, -1                 # save space on the stack (push)
                        sb $a0, ($sp)                    # save byte ($a0) from the tack
                        j next_brack                      # go to the next character in the text
               
               right_parenth: NOP 
                  bne $a0, ')', left_brack             # if $a0 != ')' try left_back
                     bne $a0, $sp, push_parenth      # if it is not equal to the top stack push to stack
                        pop_parenth:                        # take from the ')' stack
                           lb $a0, ($sp)                 # load byte from the stack
                           addi $sp, $sp, 1                # take top space on the stack (pop)
                           add $t4, $t4, 1                 # count as a pair ($t4)
                           j next_brack                    # go to the next character in the text
                     
               left_brack: NOP
                  bne $a0, '{', right_brack              # check if $a0 != } try right_brack
                     push_brack:                         # store brack into stack
                        addi $sp, $sp, -1                     # save space on the stack (push)
                        sb $a0, ($sp)                          # save byte ($a0) from the tack
                        j next_brack                        # go to the next character in the text
               
               right_brack: NOP
                  bne $a0, '}', left_square                # if $a0 is '}' try left_square
                     bne $a0, $sp, push_brack           # if it is not equal to the top stack push to stack
                        pop_brack:                         # save to the stack
                           lb $a0,  ($sp)                   # load byte from the stack
                           addi $sp, $sp, 1                  # take top space on the stack (pop)
                           add $t4, $t4, 1                  # count as a pair ($t4)
                           j next_brack                     # go to the next character in the text
                   
               left_square: NOP
                  bne $a0, '[', right_square              # check if $a0 != ']' try right_square
                     push_square:                         # store brack into stack
                        addi $sp, $sp, -1                 # save space on the stack (push)
                        sb $a0, ($sp)                          # save byte ($a0) from the tack
                        j next_brack                      # go to the next character in the text
               
               right_square: NOP
                  bne $a0, ']', next_brack          # if $a0 is ']' then error message
                     pop_square:                         # take from the ']' stack
                        bne $a0, $sp, push_square      # if it is not equal to the top stack push to stack
                           lb $a0, ($sp)                   # load byte from the stack
                           addi $sp, $sp, 1                  # take top space on the stack (pop) 
                           add $t4, $t4, 1                  # count as a pair ($t4)
                           j next_brack               # go to the next character in the text

               next_brack: NOP
                  add $t3, $t3, 1                       # move to the next character
                  j load_byte                           # jump back to load_byte
               
               check_stack:                              # checking what is in the stack
                  beq $sp, $s1, print_success                # if stack == 0 then print_success (nothing in the stack)
                     beq $sp, 1, print_mismatch          # else if stack == 1 there is a print_mismatch (only one thing)
                        j print_stacked                  # else the brackets are stacked and print_stacked
                  
               print_mismatch:                          # printing error
                  li $v0, 4                             # print the first half  
                  la $a0, mismatch                      # deallocate the mismatched bracket
                  syscall                               
                                                         # print the second half of error prompt
                  j close_file                           # jump to close file
                  
               print_stacked:
                  li $v0, 4                        # print stacked braces
                  la $a0, stacked_braces             # print the remaining braces
                  
                  j close_file                       # jump to close_file
                                                  
               print_success:                           # print the success 
                  li $v0 , 4                            # print the counted num of pairs + the success prompt
                  la $a0 , success                      # syscall to print success
                  syscall                               # execute
                  
                  #li $v0, 5                             # print the number of pairs
                  #la $a0, ($t4)                           # syscall to print int from $t4
                  #syscall                               # syscall
                  
                  #li $v0, 4                             # print second half os success
                  #la $a0, success_1                     # printing from success_1
                  #syscall                               # execute
                  
                  j close_file                          # jump to close file
                               
      close_file:                                    # to close the file after finished
         li $v0, 16                                  # sysall for closing file
         move $a0, $s0                               # move file 
         syscall                                     # close file
      
      program_exit:                                  # to program exit 
      li $v0, 10                                     # syscall to exit the program
      syscall                                        # execute
   
      
  
