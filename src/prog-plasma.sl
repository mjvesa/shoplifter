;;; Plasma
;;;
;;; Shadebob plasma
;;;
program

vars
    var a |
    var plasma |
    var time |
    var x |
    var y |
    var rx |
    var ry |
    $Const_Defs
endvars

#oldskool


$Make_Plasma_Table
$Set_Gray_Palette

;;; Draws an offsetmap
fun Draw_Plasma ->
  begin
        vars3 'index A 'color B 'index2 C
        0 {index2}
        [SCREEN_H] 1 - 0 do
            [SCREEN_W] 1 - 0 do
                [BUFFER_EDGE] j * i + {index} [index] [BM] and [plasma] @
                [index] [time]  + [BM] and [plasma] @ +
                255 and 128 - dup * 64 /
                [index2] swap putpixel2
                [index2] 1 + {index2}
            loop
        loop
        return3
    end
fend

: inc-time [time] 1 + {time}
===

fun Render_Frame ->
  (Draw_Plasma) flip inc-time
fend


main
  #constants
  $Init_Constants
  (Make_Plasma_Table)
  (Set_Gray_Palette)
  enter-rendering-loop
end-program
