;;; Draws a simple landscape

;;; ( topo texture cam-x cam-y angle -- )
fun Draw_Textured_Scape ->

    'MIN_DISTANCE 20 'MAX_DISTANCE 520

    'cam-x A 'cam-y B
    'angle C 'x D 'y E
    'x-delta F 'y-delta G
    'topo H
    'h I 'lasth J 'texture K 'color L

    : cam-angle i 256 * [SCREEN_W] / 128 - [angle] + 1023 and
    : setup-ray
      [SCREEN_H] 1 - {lasth}
      cam-angle cos {x-delta}
      cam-angle sin {y-delta}
      [cam-x] [x-delta] MIN_DISTANCE * + {x}
      [cam-y] [y-delta] MIN_DISTANCE * + {y}
    : move-ray
      [x] [x-delta] + {x}
      [y] [y-delta] + {y}
    : get-x [x] 256 /
    : get-y [y] 256 /
    : topo-point
      [x] 256 / [y] 256 / [BUFFER_EDGE] * + [BM] and
    : get-value-on-topo
      topo-point [topo] @ {h}
    : get-texture-value
      topo-point [texture] @
    : project-it
      255 [h]  - [SCREEN_H] 2 / * i / [SCREEN_H] 2 / + {h}
    : compare-to-last
        [h] [lasth] <
    : should-draw?
        get-value-on-topo project-it compare-to-last
    : for-each-pixel
       [lasth] [h] do
    : draw-vline
       should-draw? if
           get-texture-value {color}
           for-each-pixel
                i [SCREEN_W] * k +
                [color] putpixel2
           loop
           [h] {lasth}
       endif
    : for-each-scanline
        [SCREEN_W] 1 - 0 do
    : for-each-point-on-ray
        MAX_DISTANCE MIN_DISTANCE do
    ===
    vars12
    p> {angle}
    p> {cam-y}
    p> {cam-x}
    p> {texture}
    p> {topo}
    for-each-scanline
        setup-ray
        for-each-point-on-ray
            move-ray
            draw-vline
        loop
    loop
    return12
fend