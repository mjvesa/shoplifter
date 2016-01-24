;;; Initialization of various constants regarding
;;; Buffers and display. Include Const_Defs in the
;;; variable section to use this
    #constants
    [BUFFER_EDGE] dup * {BUFFER_SIZE}
    [BUFFER_EDGE] 1 - {BEM}
    [BUFFER_EDGE] 2 / {HBE}
    [BUFFER_SIZE] 1 - {BM}
    [SCREEN_W] 2 / {SCREEN_MID_X}
    [SCREEN_H] 2 / {SCREEN_MID_Y}
    [SCREEN_W] [SCREEN_H] * {SCREEN_SIZE}
