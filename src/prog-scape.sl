;;; Tunnel demo
;;;
;;; Draws a 128x128 offsetmap tunnel
;;;
program

vars
    var plasma |
    var frame  |
    $Const_Defs
endvars

#oldskool

;;; Includes
$Make_Plasma_Table
$Draw_Scape
$Set_Gray_Palette

;;; Misc
: inc-frame  [frame] 1 + {frame}
===

fun Render_Frame ->
    [plasma] >p [frame] 16 * >p 0 >p [frame] >p (Draw_Scape)
    flip
    inc-frame
fend


main
    $Init_Constants
    (Make_Plasma_Table)
    (Set_Gray_Palette)
    enter-rendering-loop
end-program