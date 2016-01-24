;;; Make_Plasma_Table
fun Make_Plasma_Table ->
    vars5 'seed A 'rx B 'ry C 'index D 'value E
    : sqr dup *
    : random [seed] 13 * 32767 and 1 + {seed} [seed]
    : saturate
        [value] 0 < if
            0 {value}
        endif
    : calc-index
      i [rx] + j [ry] + [BUFFER_EDGE] * +
      [BM] and {index}
    : get-previous-value
      [index] [plasma] @
    : calc-pixel-value
      i sqr j sqr + [BUFFER_EDGE] 4 / /
      15 swap - {value}
      saturate
    : add-value
      get-previous-value [value] +
    : store-value
      [index] [plasma] !
    : for-each-line
      [BUFFER_EDGE] 4 /
      0 [BUFFER_EDGE] - 4 / do
    : for-each-pixel
      for-each-line
    : draw-bob
      for-each-line
        for-each-pixel
          calc-index
          calc-pixel-value
          add-value
          store-value
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
