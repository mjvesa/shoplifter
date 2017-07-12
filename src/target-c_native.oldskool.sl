;;; For 320x200x8bit effects
;;; TODO Seems to need conversion to new processor

: enter-rendering-loop
"#ifdef EMSCRIPTEN" _println
"    emscripten_set_main_loop(Render_Frame, 0, 0);" _println
"#else" _println
" Main_Loop();" _println
"#endif" _println


: putpixel
  "putpixel(" _print rot _print "," _print swap _print "," _print _print ");" _println
  
;;;    print("putpixel(" .. ds[sp - 2] .. "," .. ds[sp - 1] .. "," ... ds[sp] .. ");")
;;;    sp = sp - 3
: putpixel2
    "putpixel2(" _print swap _print "," _print _print ");" _println

: flip
  "flip();" _println
: cls
  "cls();" _println
: setpal
  "palette[" _print _print " ] = " _print 65536 * swap 256 * + + _print ";" _println
;;;    print("palette[" .. ds[sp] .. " ] = " .. ds[sp - 1] .. " * 65536 + " .. ds[sp - 2] .. " * 256 + " .. ds[sp - 3] ..";")
;;;    sp = sp - 4
: include
"void putpixel(int x, int y, unsigned char color) {" _println
"    virt[(x + y * 640) & BMOD] = palette[color];" _println
"}" _println
"void putpixel2(int i, unsigned char color) {" _println
"    virt[i & BMOD] = palette[color];" _println
"}" _println
"void flip () {" _println
"    int y, x, c;" _println
"    int *from, *to;" _println
"    SDL_LockSurface(screen);" _println
"    to = (int*)screen->pixels;" _println
"    from = (int*)virt;" _println
"    for(y = 0 ; y < 400 ; y++) {" _println
"        for (x = 0 ; x < 640 ; x++) {" _println
"            c = from[x];" _println
"            to[x] = palette[c & 255];" _println
"      }" _println
"        from += 640;" _println
"        to += screen->pitch / 4;" _println
"    }" _println
"    SDL_UnlockSurface(screen);" _println
"    SDL_Flip(screen);" _println
"}" _println

"void cls() {" _println
"    memset(virt, 0, sizeof(int) * BUFFER_SIZE);" _println
"}" _println
===
include
