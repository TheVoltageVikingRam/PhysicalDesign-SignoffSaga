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

