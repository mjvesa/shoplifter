fun Draw_Bump_To_Buffer ->
  vars5 'time A 'bump B 'target C 'light D  'bump-offset E
  : clip
    [BM] and
  : calc-bump-offset
    i 2 - clip [bump] @
    i 2 + clip [bump] @ - 2 *
    i [BUFFER_EDGE] 2 * - clip [bump] @
    i [BUFFER_EDGE] 2 * + clip [bump] @ - 2 * [BUFFER_EDGE] * + i + {bump-offset}
  : sin-offset
    [time] 2 * 1023 and sin 256 +  [time] cos 256 +  [BUFFER_EDGE] * +
  ===
  p> {time} p> {bump} p> {light} p> {target}
  [BUFFER_SIZE] 1 - 0 do
    calc-bump-offset
    [bump-offset]
    sin-offset + clip
    [light] @ 240 and
    i [bump] @ 4 >> +
    i [target] !
  loop
  return5
fend
