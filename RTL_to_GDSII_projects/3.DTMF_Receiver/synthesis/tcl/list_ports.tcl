proc list_ports { } {
    foreach de [get_db ports *] {
        set baseDes [vbasename $des]
        setdirDes [vdirname $des]
        echo "$baseDes"

    }
}
