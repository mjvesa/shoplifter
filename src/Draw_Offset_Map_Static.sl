fun Draw_Offset_Map_Static ->
  vars2 'map A 'texture B
  p> {map} p> {texture}
  [SCREEN_H] [SCREEN_W] * 1 - 0 do
    i [map] @ [BM] and [texture] @
    i swap putpixel2
  loop
  return2
fend