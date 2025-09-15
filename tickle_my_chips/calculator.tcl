#!/usr/bin/env wish

# Title
wm title . "Tcl Calculator"

# Entry field (for display)
entry .display -textvariable expr -width 20 -font {Helvetica 16} -justify right
pack .display -fill x -padx 10 -pady 10

# Function to append text to expression
proc append {val} {
    global expr
    set expr "$expr$val"
}

# Function to clear display
proc clear {} {
    global expr
    set expr ""
}

# Function to evaluate expression
proc calculate {} {
    global expr
    if {[catch {expr $expr} result]} {
        set expr "Error"
    } else {
        set expr $result
    }
}

# Buttons layout
frame .buttons
pack .buttons -padx 10 -pady 10

set btns {
    {7 8 9 /}
    {4 5 6 *}
    {1 2 3 -}
    {0 C = +}
}

foreach row $btns {
    frame .buttons.row[incr i]
    pack .buttons.row$i -fill x
    foreach key $row {
        if {$key eq "C"} {
            button .buttons.row$i.b$key -text $key -width 5 -height 2 -command clear
        } elseif {$key eq "="} {
            button .buttons.row$i.b$key -text $key -width 5 -height 2 -command calculate
        } else {
            button .buttons.row$i.b$key -text $key -width 5 -height 2 -command "append $key"
        }
        pack .buttons.row$i.b$key -side left -padx 2 -pady 2
    }
}
