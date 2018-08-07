fun Make_Bumpy_Topo ->
  vars2 'target A 'value B
  : sqr 63 and 31 - dup *
  : clip [value] 63 < if 63 {value} endif
  : calc-pixel i sqr j sqr + 16 / 100 swap - {value} clip
  : store-it [value] j [BUFFER_EDGE] * i + [target] !
  : for-each-line
    [BUFFER_EDGE] 1 - 0 do
  : for-each-point
    [BUFFER_EDGE] 1 - 0 do
  ===
  p> {target}
  for-each-line
    for-each-point
      calc-pixel store-it
    loop
  loop
  return2
fend