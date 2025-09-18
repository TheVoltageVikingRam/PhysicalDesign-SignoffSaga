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
