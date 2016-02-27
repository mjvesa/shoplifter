;;; Tunnel demo
;;;
;;; Draws a 128x128 offsetmap tunnel
;;;
program

vars
  var frame   |
  var plasma  |
  var topo    |
  var light   |
  var bump    |
  $Const_Defs
endvars

#oldskool

;;; Includes
$Make_Plasma_Table
$Make_Bumpy_Topo
$Draw_Textured_Scape
$Set_16x16_Palette
$Draw_Bump_To_Buffer
$Calc_Specular_Light

;;; Misc
: inc-frame [frame] 5 + {frame}
===


fun Render_Frame ->
  : draw-scape
    [plasma] >p
    [bump] >p
    [frame] cos 2 / 256 * 256 + >p
    [frame] sin 2 / 256 * 256 + >p
    [frame] 512 + 1023 and >p
    (Draw_Textured_Scape)
  ===
  [bump] >p [light] >p [plasma] >p [frame] >p (Draw_Bump_To_Buffer)
  draw-scape
  flip
  cls
  inc-frame
fend

main
  $Init_Constants

  [BUFFER_SIZE] allot {light}
  [BUFFER_SIZE] allot {bump}
  [BUFFER_SIZE] allot {topo}
  [topo] >p (Make_Bumpy_Topo)
  [light] >p (Calc_Specular_Light)
  (Make_Plasma_Table)
  (Set_16x16_Palette)
  enter-rendering-loop
end-program