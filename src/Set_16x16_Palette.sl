begin
    'Random S16P_Random 'seed A
    $Random

    fun Set_16x16_Palette ->
        vars6 'base_colors B 'value C 'r D 'g E 'b F

        : Alloc_Base_Colors 48 allot {base_colors}
        : Set_Base_Colors
            47 0 do
                (Random) [seed] 255 and i [base_colors] !
            loop
        : Shade
            ;;; Shades a single value, capped to [0,255]
            32 * 256 - [value] + {value}
            [value] 0 < if
                0 {value}
            endif
            [value] 255 > if
                255 {value}
            endif
        : Get_R 3 * [base_colors] @ {value}
        : Get_G 3 * 1 + [base_colors] @ {value}
        : Get_B 3 * 2 + [base_colors] @ {value}
        : Calculate_Shaded_Palette
            15 0 do
                15 0 do
                    i Get_R j Shade [value] {r}
                    i Get_G j Shade [value] {g}
                    i Get_B j Shade [value] {b}
                    [r] [g] [b] i j 16 * +
                    setpal
                loop
            loop
        ===
        2331 {seed}
        Alloc_Base_Colors
        Set_Base_Colors
        Calculate_Shaded_Palette
        return6
    fend

end