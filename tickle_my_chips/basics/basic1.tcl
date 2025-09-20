#First basic tutorial

# puts - TO print
puts TCL

puts "Hello This is Ram Tripathi"
puts "Welcome to my journey in VLSI especially Physical Design"
#single line comment #
#if {0} {} -Multiple line comment

#expr, $ is to print the value of a variable

set a 5
set b 1
puts "the value of a is $a"
set c [expr $a + $b]
puts "The sum of a and b is $c"



#Arithmetic
set a 5
set b 10
set result [expr $a + $b]
set resultdiff [expr $a - $b]
set resultmult [expr $a * $b]
set resultdiv [expr $a / $b]
set exponent [expr $a ** $b]
# - * % ^
puts "Sum: $result"
puts "Diff: $resultdiff"
puts "Multiplication: $resultmult"
puts "Division : $resultdiv"
puts "Exponent : $exponent"
#Rotational ==,!=, <,>, <=, > =






# set mylist {1 2 3 4 5}
# set first {lindex $mylist 0}
# set last {lindex $mylist end}

#Bitwise OR
set a 8
set b 10
set result [expr {$a | $b} ]
puts "Bitwise OR: $result "

#Bitwise XOR
set a 6
set b 3
set result [expr { $a ^ $b }]
puts "Bitwise XOR: $result "

#Bitwise NOT
set a 6
set result [expr (~$a)]
puts "Bitwise NOT: $result "; #Output: 5 Binary 101
#Tcl handles integers as signed 32-bit, so ~6 produces -7
# In a 32-bit signed integer , the most significant bit (MSB) is the sign bit 
#The result 11111111 11111111 11111111 11111001 is interpreted as -7

set a 6
set result [expr {$a <<1}]
puts "Left Shift: $result "; #Output 12 (binary 1100) (multiply by 2)

set a 6
set result [expr {$a >> 1}]
puts "Right shift : $result ";

#Ternary Operator 
# expr {condition} > Statement1 : Statement2 


set a 10
set b 20
set c 30
set d 40

set result [ expr {$a > $b && $a > $c ? "a is greatest" : " c is greatest " }]; # ($b > $c ? "b is greatest" ; " c is greatest "))]
puts $result ;


#LIst

set mylist {1 2 3 4 5}
puts "List_mine : $mylist"

set mylist {1 2 3 4 5}
set len [llength $mylist]
puts "Length of the list : $len"

set mylist {apple banana cherry orange pineapple}
set ind 0
set item [lindex $mylist $ind]; #index starts from 0
puts "Item at index $ind: $item"

lappend mylist d e f
puts "List after appending: $mylist"

if { [lindex $mylist 0] == "apple" } {
puts "Apple is present in the list"
}

set mylist {1 2 4 5}
set newlist [ linsert $mylist 2 3 ];  # inserts 3 at index 2
puts "List after insertion : $newlist";

set mylist {a b c d e}
puts "list before replacement $mylist"
#lreplace <listname> <range of index> <value to be replaced>
set newlist [ lreplace $mylist 1 3 "Ram" "Tripathi"]; #Replace b,c,d with x y
puts "List after replacement : $newlist"

set mylist {1 2 3 4 5}
#lrange <list <range of index>
set sublist [lrange $mylist 1 3 ]; #Get elements from index 1 to 3
puts "Sublist from index 1 to 3: $sublist"

set mylist {orange apple01 banana01 cherry pineapple guava mango01 litchi}
set fruit banana
set index [lsearch -exact $mylist $fruit]

#regex is to search for a particular pattern
set index1 [lsearch -regexp -all $mylist {01$}]
puts "Index of $fruit : $index"
puts "Index of $fruit : $index1"

