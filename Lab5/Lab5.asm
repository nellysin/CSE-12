# Winter 2021 CSE12 Lab5 Template
######################################################
# Macros for instructor use (you shouldn't need these)
######################################################

# Macro that stores the value in %reg on the stack 
#	and moves the stack pointer.
.macro push(%reg)
	subi $sp $sp 4
	sw %reg 0($sp)
.end_macro 

# Macro takes the value on the top of the stack and 
#	loads it into %reg then moves the stack pointer.
.macro pop(%reg)
	lw %reg 0($sp)
	addi $sp $sp 4	
.end_macro

#################################################
# Macros for you to fill in (you will need these)
#################################################

# Macro that takes as input coordinates in the format
#	(0x00XX00YY) and returns x and y separately.
# args: 
#	%input: register containing 0x00XX00YY
#	%x: register to store 0x000000XX in
#	%y: register to store 0x000000YY in
.macro getCoordinates(%input %x %y)
	# YOUR CODE HERE
	srl %x, %input, 16                   # shift right logical to get 0x000000XX store it in x
	andi %x, %x, 0xFF                   # "and" logic to x
	andi %y, %input, 0xFF                   # "and" logic to x
.end_macro

# Macro that takes Coordinates in (%x,%y) where
#	%x = 0x000000XX and %y= 0x000000YY and
#	returns %output = (0x00XX00YY)
# args: 
#	%x: register containing 0x000000XX
#	%y: register containing 0x000000YY
#	%output: register to store 0x00XX00YY in
.macro formatCoordinates(%output %x %y)
	sll %output, %x, 16                              # shift left logical to restore 00XX0000 from x to output
	add %output, %output, %y                         # add x and y to output
.end_macro 

# Macro that converts pixel coordinate to address
# 	output = origin + 4 * (x + 128 * y)
# args: 
#	%x: register containing 0x000000XX
#	%y: register containing 0x000000YY
#	%origin: register containing address of (0, 0)
#	%output: register to store memory address in
.macro getPixelAddress(%output %x %y %origin)
         loop_address:
            mul %output, %y, 128                          # This is adding (x + 128) and storing it to output
            add %output, %output, %x                      # From the output add x
            mul %output, %output, 4                       # From output multiply by 4 and store to output
            add %output, %output, %origin                 # From output add origin andstore to output
.end_macro


.data
originAddress: .word 0xFFFF0000

.text
# prevent this file from being run as main
li $v0 10 
syscall

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Subroutines defined below
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#*****************************************************
# Clear_bitmap: Given a color, will fill the bitmap 
#	display with that color.
# -----------------------------------------------------
# Inputs:
#	$a0 = Color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
clear_bitmap: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)    
	   li $t3, 0                # counter
	   li $t4, 16384            # when to stop counting
	   lw $t0, originAddress    # load from origin address
	   
	   fill_bitmap: nop
	      sw $a0, 0($t0)           # store the color into the address of the origin address
	      addiu $t0, $t0, 4        # increment the origin address by 4
	      addi $t3, $t3, 1         # increment counter
	      bne $t3, $t4, fill_bitmap  # if counter does not equal to 16384 then repeat fill_bitmap

 	jr $ra

#*****************************************************
# draw_pixel: Given a coordinate in $a0, sets corresponding 
#	value in memory to the color given by $a1
# -----------------------------------------------------
#	Inputs:
#		$a0 = coordinates of pixel in format (0x00XX00YY)
#		$a1 = color of pixel in format (0x00RRGGBB)
#	Outputs:
#		No register outputs
#*****************************************************
draw_pixel: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	push($a0)                                      # push $a0 to stack
	push($t0)
	push($t1)
	push($t2)
	push($ra)
	
	lw $t0, originAddress                          # load the origin address to $t0
        
	getCoordinates($a0, $t1, $t2)                  # get the x and y from $a0
	
	getPixelAddress($a0, $t1, $t2, $t0)            # use getPixelAddress 
	
	sw $a1, 0($a0)                                 # store the color into the address
	
	pop($ra)                                       # pop $ra
	pop($t2)                                       # pop $t2 off stack
	pop($t1)
	pop($t0)
        pop($a0)
	
        jr $ra                         # jump to register

#*****************************************************
# get_pixel:
#  Given a coordinate, returns the color of that pixel	
#-----------------------------------------------------
#	Inputs:
#		$a0 = coordinates of pixel in format (0x00XX00YY)
#	Outputs:
#		Returns pixel color in $v0 in format (0x00RRGGBB)
#*****************************************************
get_pixel: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	push($t2)                                 # push $t2 to the stack
	push($t0)                                 # push $t0
	push($t1)
	push($ra)

	lw $t2, originAddress                       # load origin address
	
	getCoordinates($a0, $t0, $t1)              # get coordinate of given address
	getPixelAddress($a0, $t0, $t1, $t2)        # get address with origin address by getPixelAddress
	
	lw $v0, 0($a0)                             # load the color from the given coodinate (?)
	
	
	pop($ra)                                   # pop $ra
	pop($t1)                                   # pop $a0 from stack
	pop($t0)
	pop($t2)
	jr $ra                                     # jump to the register
 
#*****************************************************
# draw_horizontal_line: Draws a horizontal line
# ----------------------------------------------------
# Inputs:
#	$a0 = y-coordinate in format (0x000000YY)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_horizontal_line: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	push($t0)
	push($t1)
	push($t2)
	push($t3)
	push($t4)
	push($a0)
	push($ra)
	
	
	lw $t0, originAddress                 # load the origin address to $t0
	
	li $t1, 0x00000000
	move $t2, $a0
	formatCoordinats($a0, $t1, $t2)
	getCoordinates($a0, $t3, $t4)
	getPixelAddress($a0, $t3, $t4, $t0)     # getPixelAddress from $a0 and origin, and $t0

	sw $a1, 0($a0)
	
	pop($ra)
	pop($a0)
	pop($t4)
	pop($t3)
	pop($t2)
	pop($t1)
	pop($t0)
	
	jr $ra                                 # else jump to address


#*****************************************************
# draw_vertical_line: Draws a vertical line
# ----------------------------------------------------
# Inputs:
#	$a0 = x-coordinate in format (0x000000XX)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_vertical_line: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	
	jr $ra
 	


#*****************************************************
# draw_crosshair: Draws a horizontal and a vertical 
#	line of given color which intersect at given (x, y).
#	The pixel at (x, y) should be the same color before 
#	and after running this function.
# -----------------------------------------------------
# Inputs:
#	$a0 = (x, y) coords of intersection in format (0x00XX00YY)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_crosshair: nop
	push($ra)
	push($s0)
	push($s1)
	push($s2)
	push($s3)
	push($s4)
	push($s5)
	move $s5 $sp

	move $s0 $a0  # store 0x00XX00YY in s0
	move $s1 $a1  # store 0x00RRGGBB in s1
	getCoordinates($a0 $s2 $s3)  # store x and y in s2 and s3 respectively
	
	# get current color of pixel at the intersection, store it in s4
	# YOUR CODE HERE, only use the s0-s4 registers (and a, v where appropriate)

	# draw horizontal line (by calling your `draw_horizontal_line`) function
	# YOUR CODE HERE, only use the s0-s4 registers (and a, v where appropriate)

	# draw vertical line (by calling your `draw_vertical_line`) function
	# YOUR CODE HERE, only use the s0-s4 registers (and a, v where appropriate)

	# restore pixel at the intersection to its previous color
	# YOUR CODE HERE, only use the s0-s4 registers (and a, v where appropriate)

	move $sp $s5
	pop($s5)
	pop($s4)
	pop($s3)
	pop($s2)
	pop($s1)
	pop($s0)
	pop($ra)
	jr $ra
