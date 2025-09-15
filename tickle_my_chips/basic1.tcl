# puts - TO print
puts TCL

puts "Hello This is Ram Tripathi"
puts "Welcome to my journey in VLSI especially Physical Design"
#single line comment #
#if {0} {} -Multiple line comment

#expr, $ is to print the value of a variable

set a 5
set b 6
puts "the value of a is $a"
set c [expr $a + $b]
puts "The sum of a and b is $c"



#Arithmetic
set a 5
set b 4
set result [expr $a + $b]
# - * % ^
puts "Sum: $result"

#Rotational ==,!=, <,>, <=, > =

#Arithmetic
set a 5
set b 3
set result [expr $a + $b]
# - * / %^
puts "Sum: $result"

// set mylist {1 2 3 4 5}
// set first {lindex $mylist 0}
set last {lindex $mylist end}

