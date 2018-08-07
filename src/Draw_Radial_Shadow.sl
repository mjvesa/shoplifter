;;; Basic radial shadows
fun Draw_Radial_Shadow ->
  vars11

  'shadow-h-step A 'shadow-h B
  'lite-x C 'lite-y D
  'p-lite-x E 'p-lite-y F
  'p-lite-h G
  'hmap H 'target I 'ptr J 'h-value K

  : calc-point
    [lite-x] 256 /
    [lite-y] 256 / [BUFFER_EDGE] * +
    [BM] and {ptr}
  : get-value
    [ptr] [hmap] @ {h-value}
  : compare-value
    [h-value] [shadow-h] 256 / <
  : is-in-shadow?
    calc-point get-value compare-value
  : restart-shadow
    [p-lite-h] [h-value] 256 * - i / {shadow-h-step}
    [h-value] 256 * {shadow-h}
  : plot-lit-point
    [ptr] [hmap] @ [ptr] [target] !
  : plot-shaded-point
    0 [ptr] [target] !
  : illuminate-point
    is-in-shadow? if
      plot-shaded-point
    else
      restart-shadow
      plot-lit-point
    endif
  : advance-shadow-h
    [shadow-h] [shadow-h-step] - {shadow-h}
    [shadow-h] 0 < if
      0 {shadow-h}
    endif
  : advance-ray
    j 2 * cos [lite-x] + {lite-x}
    j 2 * sin [lite-y] + {lite-y}
  : setup-light-ray
    [p-lite-x] {lite-x}
    [p-lite-y] {lite-y}
    0 {shadow-h}
    0 {shadow-h-step}
  : for-each-angle
    511 0 do
  : for-each-point
    170 1 do
  ===
  p> {target}
  p> {hmap}
  p> {p-lite-h}
  p> {p-lite-y}
  p> {p-lite-x}
  for-each-angle
    setup-light-ray
    for-each-point
      illuminate-point
      advance-ray
      advance-shadow-h
    loop
  loop
  return11
fend
