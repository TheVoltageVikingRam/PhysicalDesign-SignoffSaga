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






// set mylist {1 2 3 4 5}
// set first {lindex $mylist 0}
set last {lindex $mylist end}

