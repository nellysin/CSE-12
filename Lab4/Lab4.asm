#################################################################################################################### 
# Created by: Sin, Nelly                                                                                           #     
#              nesin                                                                                               #        
#             16, February, 2021                                                                                   #     
#                                                                                                                  #         
# Assignment: Lab4, Syntax Checker                                                                                 #           
#             CSE 12/ 12L, Computer Systems and Assembly Language                                                  #
#             UC Santa Cruz, Winter 2021                                                                           #            
#                                                                                                                  #           
# Description: This program opens a file. Within the file, it will find the unconnected brackets                   #
#                                                                                                                  #             
# Notes:       This program is intended to be run frm the MARS IDE                                                 # 
####################################################################################################################

# Pseudocode:
#    if file_name[0] != "A-Z" or "a-z":
#       print(error: Invalid program argument)
#    else: 
#       check the rest of the characters in file_name:
#          while file_name[i] != 0
#             if i != "A-Z" or "a-z" or "." or "_":
#                print(error: Invalid program argumet)
#             else: 
#                continue through (i++)
#          else:
#             continue to opening and reading the file:
#                opening the file:
#                   open the file first
#                   get the file_name
#                   open the file_name by the given 
#                   save the file name
#
#                reading the file:
#                   read the file
#                   use buffer to save the contents inside the file by how much space to save (128)
#                   load the 128 bytes to the buffer to save the content
#                   
#             start stacking the brackets:
#                   load each individual character in the file (in_file) 
#                   check each character to find the brackets:
#                         open_parenthesis:
#                            while in_file[i] != 0
#                               if i == "(":
#                                  check the top stack
#                                  if top stack == "(":
#                                     push to stack
#                                     (i++) move to the next character
#                                  else:
#                                     push to stack
#                                     i++
#                          close_parenthesis
#                               else if i == ")":
#                                  check top stack
#                                     if top stack == "(":
#                                        pop from stack
#                                        i++
#                                     else: 
#                                        print a mismatch
# 
#                            open brace:
#                               else if i == "{":
#                                  check the top stack
#                                     if top stack == "{":
#                                        push to stack
#                                        i++
#                                     else:
#                                        push to stack
#                                        i++
# 
#                            close_brace
#                               else if i == "}":
#                                  check top stack
#                                     if top stack == "{":
#                                        pop from stack
#                                        i++
#                                     else: 
#                                        print a mismatch
#                                        i++
#                            
#                            open_square: 
#                               else if i == "[":
#                                  check the top stack
#                                     if top stack == "[":
#                                        push to stack
#                                        i++
#                                     else:
#                                        push to stack
#                                        i++
#                            
#                            close suare:
#                                  else if i == "]":
#                                     check top stack
#                                     if top stack == "[":
#                                        print mismatch
#                                        i++
#                                     else: 
#                                        print mismatch
#                                        i++
#                                  else:
#                                     continue through the characters in in_file(i++)
#                                  
#             end of stacking:
#                if the stack has nothing in it:
#                   then it was a success
#                else:
#                   there are stacked braces in the stack and print the error for stacked braces and the actual braces



.data                                                                       # .data is the saved labels

   prompt: .asciiz "You entered the file:\n"                                # A string to print when user input file name in the program argument
   
   error: .asciiz "\nERROR: Invalid program argument. \n"                   # A string to print when there is an error when it is a invalid file name
   
   mismatch: .asciiz "\nERROR - There is a brace mismatch: "                # A string to print when there is a mismatch (first half) for what the brace looks like
   mismatch_1: .asciiz " at index "                                         # A string to print when there is a mismatch (second half) this is the index location
                                                                                              
   stacked_braces: .asciiz "\nERROR - Brace(s) still on stack: "            # A string to print when there are braces that are stacked
                                                                                              
   success: .asciiz "\nSUCCESS: There are "                                 # A string to print when there is a success to matched braces (first half)
   success_1: .asciiz " of braces. \n"                                      # A string to print when there is a succes to matched braces indicating how many pairs there are (second half)
    
   buffer: .space 128                                                       # A .space to load each character of the content from the file
   
   newLine: .asciiz "\n"                                                    # This .asciiz is to print a new line
   
   
.text                                                                       # .text this is my main file
   main:                                                                           
      move $s1, $sp                                                         # Set $s1 from $sp (wil later check if the stack is 0)
      la $t3, buffer                                                        # Load the buffer in $t3              
   
      argument_input:                                                       # This program will check whether or not the name is valid
         li $v0, 4                                                          # Syscall print string 
         la $a0, prompt                                                     # Print the prompt
         syscall                                                            # Execute the following
      
         lw $a0, 0($a1)                                                     # Get file name
         move $s0, $a0                                                      # Save file name use later to open file 
         li $v0, 4                                                          # Print the file name
         syscall                                                            # Execute the following   
      
         move $t0, $a0                                                      # Moving $a0 to $t0 as temporary
      
         la $a0, newLine                                                    # Ascii for new line
         syscall                                                            # Execute print the new line
      
         li $t1, 0                                                          # This is the counter for num of characters
      
         move_char: NOP                                                     # Loop to check each character of e
            first_char:                                                     # Check the first character of the name
               lb $a0, ($t0)                                                # Load byte to the first character
               blt $a0, 65, first_lower                                     # Check if it is less than 'A' try lower case
               ble $a0, 90, valid_char                                      # Check if it is less than 'Z' go to valid_character (check the rest of the characters)
         
            first_lower:                                                    # First character to check the lower case
               blt $a0, 97, print_error                                     # If it is less than 'a' then print an error
               bgt $a0, 122, print_error                                    # If it is larger than 'z' then print an error
         
            valid_char: NOP                                                 # Loop to check if the name is valid
               bgt $t1, 20, print_error                                     # If the counter ($t1) is greater than 20 print error
               lb $a0, ($t0)                                                # Load byte to the first character $a0 will be the destination
               beqz $a0, open_file                                          # If $a0 is equal to 0, go to open_file
            
               loop_upper: NOP                                              # Check if $a0 is A-Z
                  blt $a0, 65, loop_lower                                   # If $a0 is lower than 'A' check lower case
                  ble $a0, 90, next_char                                    # Else if $a0 is less than or equal 'Z' go to next_char
               
               loop_lower: NOP                                              # Check if $a0 is a-z
                  blt $a0, 97, loop_num                                     # If $a0 is less than 0 then try loop_num
                  ble $a0, 122, next_char                                   # Else if $a0 is less than or equal to 9 go to next_char
            
               loop_num: NOP                                                # Loop for checking 0-9
                  blt $a0, 48, loop_dot                                     # If less than 0 then try loop_dot
                  ble $a0, 57, next_char                                    # Else if less or equal than 9 go to next char
            
               loop_dot: NOP                                                # Loop for checking a period
                  bne $a0, 46, loop_under                                   # If $a0 is not equal to a period try loop_under
                     j next_char                                            # Else go to the next character
            
               loop_under: NOP                                              # Loop for checking a underscore
                  bne $a0, 95, print_error                                  # If $a0 is not equal to underscore print error
                     j next_char                                            # Else go to next character
      
               next_char:                                                   # This label going to the next character
                  addi $t1, $t1, 1                                          # Increment the counter of $t1 by 1
                  addi $t0, $t0, 1                                          # Move to the next character by increment $t0
            
                  j valid_char                                              # Jump back to valid_char (end of loop)
            
      print_error:                                                          # To print the error message:
         li $v0, 4                                                          # Sycall to print a string 
         la $a0, error                                                      # Print the written error (when the file name is invalid)
         syscall                                                            # Execute the following 
     
         j program_exit                                                     # Jump to program_exit
   
      file:                                                                 # Rules of opening, reading, and closing the file
         open_file:                                                         # Opening the file given by file name
            li $v0, 13                                                      # Syscall for opening the file
            la $a0, ($s0)                                                   # Get the file name, by load address
            li $a1, 0                                                       # Syscall to open the file for reading (0)                  
            syscall                                                         # Execute following to open file
            move $s0, $v0                                                   # Save contents from $v0 to $s0
      
         read_file:                                                         # The following is to read file
            li $v0, 14                                                      # Sysall for reading the file
            move $a0, $s0                                                   # Get the saved file name
            la $a1, buffer                                                  # This buffer will hold the content in the file
            li $a2, 128                                                     # How many bytes to take in
            syscall                                                         # Execute the read_file
         
         
         stacking: NOP                                                      # Stacking brackets from file text
            li $t4, 0                                                       # $t4 is the pair count
            li $t5, 0                                                       # $t5 is the index count
         
            load_byte: NOP                                                  # Loads each byte from the text
               lb $a0, ($t3)                                                # Load each value in $a0 by how much to take in

               check_bracket: NOP                                           # Where the pointer is, count each bracket (if its a "(", "}", "]")
                  beqz $a0, check_stack                                     # If $a0 = 0 (there's nothing in $a0) then close file        
                  li $t6, 0                                                 # Reset/ set $t6 to be 0 to load byte from the stack
               
                  left_parenth: NOP                                         # Check if the character is the left parenthesis
                     bne $a0, 40, right_parenth                             # If the pointer != '(', try left_parenth
                        lb $t6, ($sp)                                       # Check the top stack by loading it to $t6
                        bne $t6, 40, push_brack                             # If $t6 is not '(' then also push to the stack
                          j push_brack                                      # Jump to push_bracket to push/ store the bracket to the stack
               
                  right_parenth: NOP 
                     bne $a0, 41, left_brack                                # If $a0 != ')' try left_back
                        lb $t6, ($sp)                                       # Check the top stack by loading it to $t6
                        bne $t6, 40, print_mismatch                         # If $t6 is not '(' then there is a mismatch
                          j pop_brack                                       # Else pop the bracket from the stack
                     
                  left_brack: NOP                                           # What to do if it the bracket is '('
                     bne $a0, 123, right_brack                              # Check if $a0 != } try right_brack
                       lb $t6, ($sp)                                        # Check the top stack by loading it to $t6
                       bne $t6, 123, push_brack                             # If $t6 is not '{' then also push to the stack
                          j push_brack                                      # Jump to push_bracket to push/ store the bracket to the stack
               
                  right_brack: NOP                                          # What to do if the bracket is ')'
                     bne $a0, 125, left_square                              # If $a0 is '}' try left_square
                        lb $t6, ($sp)                                       # Check the top stack by loading it to $t6
                        bne $t6, 123, print_mismatch                        # If $t6 is not '{' then there is a mismatch
                          j pop_brack                                       # Else pop the bracket from the stack
                   
                  left_square: NOP                                          # What to do if the bracket is '[' 
                     bne $a0, 91, right_square                              # Check if $a0 != '[' try right_square
                        lb $t6, ($sp)                                       # Check the top stack by loading it to $s2
                        bne $t6, 91, push_brack                             # If $t6 is not '[' then also push to the stack
                           j push_brack                                     # Jump to push_bracket to push/ store the bracket to the stack
               
                  right_square: NOP                                         # What to do if the bracket is ']'
                     bne $a0, 93, next_brack                                # If $a0 is ']' then error message
                        lb $t6, ($sp)                                       # Check the top stack by loading it to $s2
                        bne $t6, 91, print_mismatch                         # If $t6 is not '[' then there is a mismatch
                           j pop_brack                                      # Else pop the bracket from the stack

               push_brack: NOP                                              # Save it to the stack
                  addiu $sp, $sp, -1                                        # Save space on the stack (push)
                  sb $a0, ($sp)                                             # Save byte ($a0) from the stack
                  
                  j next_brack                                              # Go to the next character in the text
                  
               
               pop_brack: NOP                                               # Take from where $sp is in the stack
                  lb $a0, ($sp)                                             # Load byte ($a0) from the $sp
                  addiu $sp, $sp, 1                                         # Take top space on the stack (pop) add $sp
                  addi $t4, $t4, 1                                          # Count as a pair ($t4)
                  
                  j next_brack                                              # Go to the next character in the text
                  
               next_brack: NOP                                              # The following shows how to get to the next bracket/ character in the content file
                  addi $t3, $t3, 1                                          # Move to the next character
                  addi $t5, $t5, 1                                          # Index for where the mismatched bracket is
                  
                  j load_byte                                               # Jump back to load_byte
                 
            check_stack:                                                    # Checking what is in the stack
               beq $sp, $s1, print_success                                  # If stack == 0 then print_success (nothing in the stack)
                  
                  j print_stacked                                           # Else the brackets are stacked and print_stacked
                  
               print_mismatch:                                              # Label for printing a mismatch
                  li $v0, 4                                                 # Print the first half  
                  la $a0, mismatch                                          # Deallocate the mismatched bracket
                  syscall                                                   # Execute the following
                  
                  lb $a0, ($t3)                                             # Load byte to $a0 from $t3
                  li $v0, 11                                                # Syscall to print the bracket or string
                  syscall                                                   # Execute the following
                  
                  li $v0, 4                                                 # Syscall to print a string
                  la $a0, mismatch_1                                        # The second part of the mismatch error (mismatch_1)
                  syscall                                                   # Execute the following
                  
                  li $v0, 1                                                 # Syscall to print a integer 
                  la $a0, ($t5)                                             # Print the location of the mismatch ($t5)
                  syscall                                                   # Excute the following
                  
                  li $v0, 4                                                 # Syscall to print a string
                  la $a0, newLine                                           # Load address to print a new line from newLine
                  syscall                                                   # Execute the following 
                                 
                  j close_file                                              # Jump to close file
                  
               print_stacked:                                               # Print the error if there are stacked braces
                  li $v0, 4                                                 # Syscall to print strings
                  la $a0, stacked_braces                                    # Print the first half of the stacked_braces
                  syscall                                                   # Execute the following
                  
                  stack_error: NOP                                          # The following loop will print the actual stacked braces
                  beq $sp, $s1, end_statement                               # If the stack is empty then end the statement from end_statement
                     lb $a0, ($sp)                                          # Load byte from the stack
                     li $v0, 11                                             # Then print syscall to print asciiz
                     syscall                                                # Execute the following
                  
                     addiu $sp, $sp, 1                                      # Pop/ remove top space on the stack 
                     
                     j stack_error                                          # Jump back to the stack_error loop
                  
                  end_statement:                                            # End_statement is a label to end the statement
                     li $v0, 4                                              # Syscall to print a string from asciiz 
                     la $a0, newLine                                        # Print the newLine from .data
                     syscall                                                # Execute the following
                     
                     j close_file                                           # Then jump to close file to end the program
                                                                                              
                                                                                              
               print_success:                                               # The following will print the number of pairs if there are matched braces
                  li $v0 , 4                                                # Syscall to print a string
                  la $a0 , success                                          # Print success from .data
                  syscall                                                   # Execute the following
                  
                  print_pairs:
                     li $v0, 1                                              # Print the number of pairs
                     la $a0, ($t4)                                          # Syscall to print int from $t4 (pair counter)
                     syscall                                                # Execute the following
                  
                  li $v0, 4                                                 # Print second half of success sentence
                  la $a0, success_1                                         # Printing from success_1 from .data
                  syscall                                                   # Execute the following
                  
                  j close_file                                              # Jump to close file
                               
      close_file:                                                           # To close the file after finished processing 
         li $v0, 16                                                         # Sysall for closing file (16)
         move $a0, $s0                                                      # Move file from $s0 to $a0
         syscall                                                            # Execute close_file
      
      program_exit:                                                         # To exit the program
      li $v0, 10                                                            # Syscall to exit the program (11)
      syscall                                                               # Execute the folowing
   
      
  
