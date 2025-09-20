#Write a TCL script to read the values on an array and print it using foreach loop
#Initialize an array with some values

set myArray(0) "apple"
set myArray(1) "banana"
set myArray(2) "cherry"
set myArray(3) "date"
set myArray(4) "elderberry"

#Using foreach loop to iterate over the array and print each element

foreach key [array names myArray] {
    set value $myArray($key)
    puts "Index $key : $value"
}


proc decimal_to_binary {decimal} {
    set binary ""
    #Handle the case for zero
    if {$decimal == 0} {
        return "0"
    }

    #Convert decimal to binary
    while {$decimal > 0} {
        set remainder [expr {$decimal % 2}]
        set binary "$remainder$binary"
        set decimal [expr {$decimal / 2}]

    }
    return $binary
}

#example usage
puts "Enter a decimal number: "
gets stdin decimal

#Call the function and print the result
set binary_result [decimal_to_binary $decimal]
puts "Binary Representation: $binary_result"

#Write a TCL script to check if a number is even or odd.
#Procedure to check if a number is even or odd

proc check_even_odd {num} {
    if {($num % 2) == 0} {
        puts "$num is even"
    } else {
        puts "$num is odd."
    }
}

#prompt for user input
puts "Enter a number:"
gets stdin number

#Call the procedure with the user's input
check_even_odd $number


#sum of numbers in an array

#Define a list of numbers
set numbers {10 20 30 40 50}

#initailise the sum to zero
set num 0

#Use foreach loop to iterate over the kist and calculate the sum
foreach num $numbers {
    incr sum $num ; #add the current number to the sum
}

#print the sum

puts "The sum of the numbers is : $sum"