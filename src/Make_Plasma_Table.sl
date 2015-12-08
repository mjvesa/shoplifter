;;; Make_Plasma_Table
fun Make_Plasma_Table ->
    vars5 'seed A 'rx B 'ry C 'index D 'value E
    : sqr dup *
    : random [seed] 13 * 32767 and 1 + {seed} [seed]
    : saturate
        [value] 0 < if
            0 {value}
        endif
    : draw-bob
        15 -16 do
            15 -16 do
                i [rx] + j [ry] + [BUFFER_EDGE] * + ;;; Where to store
                [BM] and {index}                    ;;; Wrap it to buffer
                [index] [plasma] @                  ;;; Previous value
                i sqr j sqr + 16 /
                15 swap - {value}                   ;;; Calc pixel value
                saturate
                [value] + [index] [plasma] !        ;;; Store value
            loop
        loop

    ;;; Allocate and clear plasma table
    : allocate-plasma-table
        [BUFFER_SIZE] allot {plasma}
        [BM] 0 do
            0 i [plasma] !
        loop

    : init-seed 2331 {seed}
    ===

    init-seed
    allocate-plasma-table
    1000 0 do
        random {rx} random {ry} draw-bob
    loop
    return5
fend
