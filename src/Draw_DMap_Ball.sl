;;; Draws a displacement mapped ball using a polar table
;;; The resulting image is in polar coordinates and must be
;;; remapped to rectangular coordinates using a polar table
fun Draw_DMap_Ball ->
  vars12
    'rx A 'ry B 'rx-delta C 'ry-delta D
    'cam-x E 'cam-y F 'h G 'color H 'lasth I
    'topo J 'texture K 'target L
  : set-camera-origin
    [cam-x] {rx} [cam-y] {ry}
  : scale-angle
    1024 [BUFFER_EDGE] / *
  : set-camera-direction
    i scale-angle cos {rx-delta} 
    i scale-angle sin {ry-delta}
  : setup-slice-ray
    set-camera-origin set-camera-direction
    0 {h} 0 {lasth}
  : for-each-angle
    [BUFFER_EDGE] 1 - 0 do
  : for-each-slice-point
    [BUFFER_EDGE] 1 - 0 do
  : get-current-offset
    [rx] 256 / [ry] 256 / [BUFFER_EDGE] * + [BM] and
  : get-topo-point
    get-current-offset [topo] @
  : project-point
    64 + i scale-angle 2 / sin * 256 / {h}
  : get-color
    get-current-offset [texture] @ {color}
  : draw-slice
    get-color
    [h] [lasth] do
      [color] k [BUFFER_EDGE] * i + [target] !
    loop
  : is-visible?
    [h] [lasth] > if
  : draw-if-visible
    is-visible?
      draw-slice
      [h] {lasth}
    endif
  : move-ray
    [rx] [rx-delta] + {rx}
    [ry] [ry-delta] + {ry}
  ===
  p> {target} p> {texture} p> {topo}
  p> {cam-y} p> {cam-x}
  for-each-angle
    setup-slice-ray
    for-each-slice-point
      get-topo-point project-point
      draw-if-visible move-ray
    loop
  loop
  return12
fend

