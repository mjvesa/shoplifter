fun Draw_Bump ->
        vars5 'time A 'plasma B 'index C 'pixel-index D 'bump-offset E
        p> {time} p> {plasma}
        : Clip
            [BM] and
        : Bump_Offset
            [index] 1 - Clip [plasma] @
            [index] 1 + Clip [plasma] @ - i +
            [index] [BUFFER_EDGE] - Clip [plasma] @
            [index] [BUFFER_EDGE] + Clip [plasma] @ - j +
            [BUFFER_EDGE] * +
            {bump-offset}
        : Sin_Offset
            [time] sin [time] cos [BUFFER_EDGE] * +
        ===
        0 {pixel-index}
        [SCREEN_H] 1 - 0 do
           [SCREEN_W] 1 - 0 do
                j [BUFFER_EDGE] * i + [BM] and {index}
                Bump_Offset
                [bump-offset]
                Sin_Offset  + Clip [light] @ 240 and
                [index] [plasma] @ 16 / +
                [pixel-index] swap putpixel2
                [pixel-index] 1 + {pixel-index}
            loop
        loop
        return5
fend
