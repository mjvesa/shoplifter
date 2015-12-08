;;; Draws a simple landscape
fun Draw_Scape ->

    'MIN_DISTANCE 100 'MAX_DISTANCE 300

    'cam-x A 'cam-y B
    'angle C 'x D 'y E
    'x-delta F 'y-delta G
    'topo H
    'h I 'lasth J

    : cam-angle i [angle] +
    : setup-ray
        [cam-x] {x} [cam-y] {y}
        cam-angle cos {x-delta}
        cam-angle sin {y-delta}
    : move-ray
      [x] [x-delta] + {x}
      [y] [y-delta] + {y}
    : get-x [x] 256 /
    : get-y [y] 256 /
    : topo-point
        [x] 256 / [y] 256 / [BUFFER_EDGE] * +
    : get-value-on-topo
        topo-point [BM] and [topo] @ {h}
    : project-it
        [h] 2 / 128 - 256 * i / 20 + {h}
    : compare-to-last
        [h] [lasth] <
    : should-draw?
        get-value-on-topo project-it compare-to-last
    : for-each-pixel
       [lasth] [h] do
    : draw-hline
       should-draw? if
           for-each-pixel
                i [SCREEN_W] * k +
                get-x get-y xor putpixel2
           loop
           [h] {lasth}
       endif
    : for-each-scanline
        [SCREEN_W] 1 - 0 do
    : for-each-point-on-ray
        199 {lasth}
        MAX_DISTANCE MIN_DISTANCE do
    ===
    vars10
    p> {angle}
    p> {cam-y}
    p> {cam-x}
    p> {topo}
    for-each-scanline
        setup-ray
        for-each-point-on-ray
            move-ray
            draw-hline
        loop
    loop
    return10
fend