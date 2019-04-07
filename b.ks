function func {
    parameter a.

    local b is 0.
    until false {
        set b to b + 1.
        print b.
        if b > a {
            break.
        }
    }
}