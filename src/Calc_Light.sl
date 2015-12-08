fun Calc_Light ->
        vars1 'value A
        : sqr [HBE] - dup *
        : clip
            [value] 0 < if
                0 {value}
            endif
;;;        $Saturate
        ===
        [BUFFER_SIZE] allot {light}
        [BEM] 0 do
            [BEM] 0 do
                i sqr j sqr + 16 /
                255 swap - {value} clip
                [value] j [BUFFER_EDGE] * i + [light] !
            loop
        loop
        return1
fend
