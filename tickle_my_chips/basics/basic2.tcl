#Second tutorial
#Ram Tripathi
#using ternary operations
set x 15
set y 25
set z 10


set result [expr {$x > $y ? "x is greatest" : (y > $z ? "y is greatest" : "z is greatest")}]
puts $result

set mylist {apple banana cherry}
puts "$mylist"

#join <list_name> <value with which list should be joined>

set str [ join $mylist ", "]

puts "joined list: $str"

set str "apple banana cherry"
set mylist [split $str "a"] 
puts "List from string : $mylist"


set mylist {5 3 8 1 2}
set sorted [lsort $mylist]
puts "sorted list {ascending}: $sorted"
set sorted [lsort -decreasing $mylist]
puts "sorted list {decreasing}: $sorted"

set list1 {a b c}
set list2 {d e f}

set combined [concat $list1  $list2]
puts "Concatenated list $combined"
set mylist {a b c d}
set index [lsearch $mylist "c"]
puts "Index of c : $index"

set mylist {1 2 3 4 5}
set reversed [lreverse $mylist]
puts " Reversed list: $reversed"


set mylist {1 2 3 4 5 6}
set first [lindex $mylist 0]
set last [lindex $mylist end]
puts "first element : $first"
puts "last element : $last"

set mylist {apple banana cherry}

lassign $mylist first second third
puts "First element: $first"
puts "Second element: $second"
puts "Third element: $third"

set mylist {a b c d e}
# Assign the first two elements to variables , the rest of the list goes to "others"
lassign $mylist first second others
puts "First: $first"
puts "second $second"
puts "Others: $others"


lassign {d e} x y z
puts $x
puts $y
puts $z

#Array  - assign values using an index {key}
#creating an associative array
#array <name of the array> [<values of the array>]

array set myarray1 {apple red banana yellow cherry red rose pineapple}
puts [array get myarray1]

#tcl arrays are associative arrays
#also called as hash maps or dictionaries in other programming languages
#THey do not guarantee or preserve the order of their elements because the data is
#stored based on hashed keys for efficient access, not in the order of insertion

#CReating an indexed array

set myarray(0) 10
set myarray(1) 20
set myarray(2) 30
puts [array get myarray]

set colors(red) "FF0000"
set colors(green) "00FF00"
set colors(blue) "0000FF"

puts [array get colors]


set colors(red) "FF0000"
set colors(green) "00FF00"
set colors(blue) "GHI"
set allElements [array get colors]
puts [array size colors]
puts "$allElements"
set a 10
set b 20

if {$a > $b} {
    puts "a is greater than b"
} else {
    puts "b is greater than or equal to a"
}

set a 15 
if {$a < 10} {
    puts "a is less than 10"
} elseif {$a==10} {
    puts "a is equal to 10"
} else {
    puts "a is greater than or equal to 10"
}

set i 1
while {$i <= 5} {
    puts $i
    incr i
}

for {set i 1} {$i <=5 } {incr i} {
    puts $i
}

#Example 1: Iterating through a list

set fruit {apple banana cherry}
foreach fruit $fruit {
    puts $fruit
}