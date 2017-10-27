# COMP 303 : ASSIGNMENT 2

In this project, we are asked to implement Insertion sort algorithm with duplicate removal and reduction using MIPS assembly language in MARS Simulator.

Mert Atila Sakaogullari 49768
Y.O.Y.

## Getting Started

First we get the list size from the user. We display a message and save to input.

```
List size n is kept in $s0
```

If the size is given to be 0 or less then 0, the program will display an error message and terminate:

```
Error: The list size cannot be less than or equal to 0 ! \n
```

### Looping till we get the list

According to the size, we ask the user for inputs and store them in the memory in a Decrement After, Increment Before type stack. This is done by the **input_loop**

```
$sp's current address will be stored in $s1 and called when required
```

When we finish collecting the inputs, we call the **print_list** to display the list as shown below:

```
Unsorted List 
 => [ _element0_ _element1_ _element2_ ... _element(n-1)_ ]
```

We have the main body of our print label as output_list, for this part, we want the project to do insertion sort after printing unsorted list. So we set $a2 and $a3 just an integer, which will satisfy beq instruction afterward and move to insertion_sort

## Insertion Sort

Our insertion sort has two nested loops. **insertion_sort_loop_1** is going through elements one by one, beginning from index = 1 and **insertion_sort_loop_2** compares that element with it's predecessor. If the element is less then it's predecessor, we switch these two elements. We call our function **switch_them** and this will call **insertion_sort_loop_2** back for the same element we just switched with it's predecessor. This way this switch will be made as long as that element is less than the elements in smaller indexes. At the point where it is is not less than it's predecesoor, we jump to **insertion_sort_loop_1** and work on the one next element which we were left before switching because we don't need to go on and do unnecessary comparisons. 

After the inseriton sort, **print_sorted_list** will be called and the list will be displayed as shown below:

```
Sorted List
 => [ _elementi_ _elementj_ ... ]
```

Here when we call the printing function, main body is the same but this time we set $a2 to an integer less than $a3 so after the printing process is completed, it will branch to **removing_duplicates**

## Removing Duplicates

Now that we have the sorted list, we will get rid of the duplicates. We pull $sp back from $s1 and again loop goes one by one for each element beginning from index = 1 and compare it again with it's predecessor. We call the i of this loop as a cursor and it shows us where we are. We begin from cursor = 0 and increment it by 1 at the beginning of  **loop_for_removal**. 
* When the comparison shows that two elements are same, our cursor is showing the second element and we just move all the rest of the list up by one, by calling **update_the_rest**. 

```
Here first $s0 becomes $s0 - 1 because we found a repetitive element, therefore the size will be decreased by one when we delete that
```

**update_the_rest** overwrites the repeated element and moves all the elements in the list up by one in **loop_for_update**. When that update is complete we decrement the cursor by 1 before calling the same loop because otherwise when it gets incremented by 1 at the beginning of the loop, we'll miss checking the comparison of the previous element with the new overwrited element we've carried up.

* When the removal is finished we call the **insertion_sort_loop_2** which displays the message and then uses **output_loop** to print the list to customer as shown below:

```
Removing duplicates
 => [ _elementi_ _elementj_ ... ]
```

In **print_removed_list** we set $a3 to be greater than $a2 so this time when **output_loop** is finished we'll move to the Reduction part.

## Reduction

Here in **calculate_the_sum** we first assign 0 to $s2. Then loop with **loop_sum** on the elements and keep adding their values to $s2.

```
$s2 is simply where the sum is kept
```

After **loop_sum** is completed, we call **print_sum**. It displays the sum as shown below:

```
Reduction
 => _The Sum_
```

Then the program is terminated with the following message:

```
-- program is finished running --
```

## Deployment

### Built With

* [MARS MIPS simulator](http://courses.missouristate.edu/KenVollmar/mars/)

### Authors

* **Mert Atila Sakaogullari / 49768** 
* **Y.O.Y.**


