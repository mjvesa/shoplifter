    vars5 'x A 'y B 'radius C 'angle D 'polar E
    ;;; --- project
    : sqr dup *
    : pythagoras [x] [SCREEN_MID_X] - sqr [y] [SCREEN_MID_Y] - sqr +
    : get-x-and-y i [SCREEN_W] mod {x} i [SCREEN_W] / {y}
    : calc-radius pythagoras sqrt {radius}
    : calc-angle
            [x] [SCREEN_MID_X] - 256 * [y] [SCREEN_MID_Y] - {angle}
            [angle] 0 = if
                1 {angle}
            endif
            [angle] / atan [BUFFER_EDGE] * 512 / {angle}
            [y] [SCREEN_MID_Y] >= if
                [angle] [BUFFER_EDGE] 2 / + {angle}
            endif
    : calc-offset-value [radius] [angle] [BUFFER_EDGE] * +
    : store-it i [polar] !
    ===
    p> {polar}
    [BM] 0 do
        get-x-and-y
        calc-radius project
        calc-angle
        calc-offset-value
        store-it
    loop
    return5

