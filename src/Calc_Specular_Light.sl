fun Calc_Specular_Light ->
  vars2 'value A 'light B
  : sqr [HBE] - dup *
  : clip
    [value] 255 > if
      255 {value}
    endif
;;;        $Saturate
  ===
  p> {light}
  [BEM] 0 do
    [BEM] 0 do
      i sqr j sqr + [BUFFER_EDGE] 3 / / 1 +
      10000  swap / {value} clip
      [value] j [BUFFER_EDGE] * i + [light] !
    loop
  loop
  return2
fend
