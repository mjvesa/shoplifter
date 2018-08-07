;;;
program

vars
    var texture  |
    var prev     |
    var plasma   |
    var frame    |
    var ball     |
    var polartab |
    $Const_Defs
endvars

#oldskool

;;; Includes
$Make_Bumpy_Topo
$Draw_DMap_Ball
$Calc_Flower_Table
$Set_Colorful_Palette
$Draw_Offset_Map_Static
$Draw_Radial_Shadow

;;; Misc
: inc-frame  [frame] 1 + {frame}
: temporal-blur
  [BM] 0 do
    i [texture] @ i [prev] @ 3 * + 4 / i [texture] !
    i [texture] @ i [prev] !
  loop
===

fun Clear ->
  vars1 'target A
  p> {target}
  [BM] 0 do
    0 i [target] !
  loop
  return1
fend



fun Render_Frame ->
  [frame] 4 * cos 200 * >p
  [frame] 4 * sin 200 * >p
  110 256 * >p
  [plasma] >p
  [texture] >p
  (Draw_Radial_Shadow)
  temporal-blur
  [frame] 256 * >p [frame] 256 * >p [plasma] >p [texture] >p [ball] >p (Draw_DMap_Ball)
  [ball] >p [polartab] >p (Draw_Offset_Map_Static)
  flip
  inc-frame
  [texture] >p (Clear)
  [ball] >p (Clear)
  
fend

main
  $Init_Constants
  [BM] allot {plasma}
  [BM] allot {texture}
  [plasma] >p (Make_Bumpy_Topo)
  (Set_Colorful_Palette)
  0 {frame}
  [BM] allot {polartab} [polartab] >p (Calc_Flower_Table)
  [BM] allot {ball}
  [BM] allot {prev}
  enter-rendering-loop
end-program