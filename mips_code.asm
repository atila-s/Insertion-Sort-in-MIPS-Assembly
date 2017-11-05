#####################################################################
#                                                                   #
# Name:      Mert Atila Sakaogullari  / Y.O.Y.                      #
#####################################################################

# Assignment 2
# MIPS assembly code for the assignment

.eqv MAX_LEN_BYTES 400

#====================================================================
# Variable definitions
#====================================================================

.data
input_data:        .space    MAX_LEN_BYTES
input_msg:         .asciiz "Input size of the list: "
input_msg_2:         .asciiz "Input integers: "
input_msg_3: .asciiz "\nUnsorted List \n => "
input_msg_4: .asciiz "\nSorted List\n => "
input_msg_5: .asciiz "\nRemoving duplicates\n => "
input_msg_6: .asciiz "\nReduction\n => "
input_msg_space:        .asciiz    " "
input_msg_open_bracket: .asciiz    "[ "
input_msg_close_bracket: .asciiz    "]"

error_msg: .asciiz "\n The list size cannot be less than or equal to 0 ! \n "

#==================================================================== 
# Program start
#====================================================================

.text
.globl main

main:
  

start_input:
	la $a0, input_msg       # Output message to input size of the list
	li $v0, 4		   # Setting $v0 to print the message
	syscall

	la $a0, input_data      # address of input_msg

	li $v0, 5               # system call for keyboard input, we get the size of the list
	syscall

 	add $s0,$v0,$zero      #size of our list is at $s0
  	add $t0,$zero,$zero    #loop count i is $t0
  
  	addi $t0,$zero,1
  	blt $s0,$t0, invalid_size #We should check for the inputs which the user shouldn't be allowed to
  	
input_loop:
  	la $a0, input_msg_2      # Output message to input numbers
  	li $v0, 4		   # Setting $v0 to print the message
  	syscall

  	la $a0, input_data     # address of input_msg_2

  	li $v0, 5                # system call for keyboard input, we get the size of the list
  	syscall
  
  	sw $v0,0($sp)            #store the input integer to sp's address
  	addi $sp, $sp, -4        #move sp to one more byte down
  	addi $t0, $t0, 1         #increase loop counter i
  	blt $t0,$s0, input_loop  #if we still didn't complete the list, loop
  
  	sll $t1,$s0,2            #the amount of bytes we pushed sp
  	add $sp,$sp,$t1         #we move to the top of in the memory, to our first element
  
  	and $t0,$t0,$zero        #$t0 will be our loop counter i again, this time for the insertion sort
  	add $s1,$zero,$sp        #we make a copy of our current $sp
 
  ## Printing the list we've obtained:
  
  	la $a0, input_msg_3        # Output message to input size of the list
  	li $v0, 4		   # Setting $v0 to print the message
  	syscall
  	addi $a2,$zero,5           #$a2 and $a3 registers are used for returns from printing function
  	add $a3,$zero,$a2	   #the numbers we assign are not important, the compare inbetween is what we'll use
  	j print_list
  
  
insertion_sort_loop_1:		 #this loop is doing insertion for each element beginning from index 1
  	addi $t0,$t0,1           #increment the loop counter by 1
  	beq $t0,$s0, print_sorted_list #when finished, print the outputlist
  	sll $t1,$t0,2            #we'll move to the current elements address
  	sub $sp,$s1,$t1          #we move the start $sp to the $t1'th element's address
  
insertion_sort_loop_2:			#this loop is doing insertion for each element in the outer loop "insertion_sort_loop_1"
  	lw $a0,0($sp)			#load the current element
  	lw $a1,4($sp)			#check the element right in front of that
  	blt $a0,$a1, switch_them	#if the later element is less than the previous one, switch them
  	j   insertion_sort_loop_1	#if the order is correct, move to next element in the outer loop
 

Exit:   
   # Exit program
   li $v0, 10
   syscall
   
switch_them:				#switching two elements $a0 and $a1, $a1 was the previous one
	sw $a1,0($sp)
 	sw $a0,4($sp)
 	addi $sp,$sp,4
 	beq $s1,$sp, insertion_sort_loop_1	#if we've moved to the first element, we move directly to the outer loop
 	j  insertion_sort_loop_2		#if we didn't switch with the first element with index 0, we still have more checks to do
 

print_sorted_list:				#printing the sorted list
  	addi $a2,$zero,3			#arranging $a2 and $a3 so that we proceed afterwards to next step: removing duplicates
  
  	la $a0, input_msg_4       		# Output message to input size of the list
  	li $v0, 4		   		# Setting $v0 to print the message
  	syscall
 
print_list:
 	la $a0, input_msg_open_bracket       # Set the message to open the bracket
 	li $v0, 4		              # Setting $v0 to print the message
 	syscall
  
	addi $t2,$zero,0       		#loop counter for printing
	add $sp,$s1,$zero     		 #setting $sp back to the top of the list

output_loop:		#main loop which moves one by one on the list and prints that element
	lw $a0,0($sp)
	li $v0, 1
	syscall
	subi $sp,$sp, 4
	addi $t2,$t2,1
	la $a0, input_msg_space       # Output message is space to distinguish different elements
	li $v0, 4		      # Setting $v0 to print the message
	syscall

	blt $t2,$s0, output_loop      #if we still have elements remaining elements, we keep on printing
 
	la $a0, input_msg_close_bracket       # When the list is finished, set the message to close the bracket
	li $v0, 4		              # Setting $v0 to print the message
	syscall
	beq $a2,$a3,insertion_sort_loop_1     #this $a2, $a3 comparison resulting true means we do the search now
	blt $a2,$a3,removing_duplicates	      #this $a2 and $a3 comparison resulting true means we proceed to removing steps now
	j calculate_the_sum

removing_duplicates: #Main idea is after we find an element same with it's predecessor, we update the rest of the list and overwrite that element
	add $sp,$s1,$zero		 #get the beginning sp address back
	addi $t3,$zero,0 		 #this is the cursor we move on the list as we compare each element with it's predecessor in the loop
	j loop_for_removal		 #this is the loop for the comparisons

check_the_cursor:			 #If we find an elements same like that, the element which overwrites it can also be same with the same precedessor
	subi $t3,$t3,1			 #We substract one from our cursor, so when the loop begins and when we add 1, we'll also check the same index

loop_for_removal:
	addi $t3,$t3,1			 	#We move the cursor by one 
	beq $t3,$s0,print_removed_list		 #If the cursor surpassed the last index, it is finished
	sll $t6,$t3,2				 #Converting the cursors' size to address
	sub $sp,$s1,$t6				 #We update the $sp directly from the back up $s1 and it's relation to $t6
	lw $a0,0($sp)				 #We load the predecessor of the element shown by the cursor
	lw $a1,4($sp)				 #We load the element shown by the cursor
	beq $a0,$a1,update_the_rest		 #if they are the same, we update the list
	j loop_for_removal			 #If these two elements are not the same, we keep looping


update_the_rest:
	sub $s0,$s0,1				#We subtract 1 from the size of the list, which is kept in $s0
	sub $t4,$s0,$t3				#We subtract the cursor's index from the size, give how many elements we'll move
	
loop_for_update:
	beq $t4,$zero, check_the_cursor		#If we've moved all the elements, we go back to check the cursor's point and then keep looping for removal
	sub $sp,$sp,4				#We move 1 element below in stack
	lw $a0,0($sp)				#We load the subsequent element and overwrite the repeating element
	sw $a0,4($sp)
	subi $t4,$t4,1				#Then we decrease the number of elements we'll move because we just moved one
	j loop_for_update			#When we still have elements to move, we keep this loop



print_removed_list:
	addi $a3,$zero,0	#We update $a3 in a way that when we call output_loop to print, it will exit afterwards

	la $a0, input_msg_5       # Set the message to show the removed list
	li $v0, 4		  # Setting $v0 to print the message
	syscall

	addi $t2,$zero,0       #loop counter for printing, needed for the call for output_loop
	add $sp,$s1,$zero      #setting $sp back to the top of the list, again needed for output_loop

	la $a0, input_msg_open_bracket  	#Set the message to open the bracket
	li $v0, 4		  		# Setting $v0 to print the message
	syscall
	j output_loop
	
calculate_the_sum:
	addi $s2,$zero,0		#We'll keep the sum in $s2
	and $t7,$t7,$zero		#$t7 will be our counter
	add $sp,$s1,$zero		#We get the beginning address from our back up stored in $s1
		
loop_to_sum:
	beq $t7,$s0,print_sum		#If we've added all the elements, then we are done
	lw $a0,0($sp)			#We load the element
	add $s2,$s2,$a0			#we add that element to our sum
	addi $t7,$t7,1
	subi $sp,$sp,4
	j loop_to_sum
	
print_sum:
  	la $a0, input_msg_6        # Output message to input numbers
  	li $v0, 4		   # Setting $v0 to print the message
  	syscall
  	
  	add $a0,$zero,$s2	  #We print the sum of all the element
	li $v0, 1
	syscall
  	
	j Exit		 	# aaaand it's time to call it a day!

invalid_size:
  	la $a0, error_msg        # Output message to input numbers
  	li $v0, 4		   # Setting $v0 to print the message
  	syscall
	j Exit

  	
