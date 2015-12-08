;;; Bump
;;;
;;; Basic bump mapping 
;;;
program


vars
      var plasma |
      var light  |
      var frame  |
      $Const_Defs
endvars

#oldskool

;;; Includes
$Make_Plasma_Table
$Draw_Bump
$Calc_Light
$Set_16x16_Palette


;;; Misc
: inc-frame  [frame] 1 + {frame}
===


fun Render_Frame ->
    [plasma] >p [frame] >p (Draw_Bump)
    flip
    inc-frame
fend

main
    $Init_Constants
    (Calc_Light)
    (Make_Plasma_Table)
    (Set_16x16_Palette)
    enter-rendering-loop
end-program