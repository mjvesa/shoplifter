;;; For 320x200x8bit effects
*** include

print([[
void putpixel(int x, int y, unsigned char color) {
    virt[(x + y * 320) & BMOD] = palette[color];
}

void putpixel2(int i, unsigned char color) {
    virt[i & BMOD] = palette[color];
}

void flip () {
    int y, x, c, lw, lw2, lw3;
    int *from, *to;

    SDL_LockSurface(screen);

    lw = screen->pitch / 4;
    to = (int*)screen->pixels;
    from = (int*)virt;
    for(y = 0 ; y < 200 ; y++) {
        for (x = 0 ; x < 320 ; x++) {
            c = from[x];
            to[x * 2] = c;
            to[x * 2 + 1] = c;

            to[x * 2     + lw] = c;
            to[x * 2 + 1 + lw] = c;
      }
        from += 320;
        to += screen->pitch / 2;
    }

    SDL_UnlockSurface(screen);
    SDL_Flip(screen);
}
]])
===
include
