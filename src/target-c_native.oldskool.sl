;;; For 320x200x8bit effects
*** include

print([[
void putpixel(int x, int y, unsigned char color) {
    virt[(x + y * 640) & BMOD] = palette[color];
}

void putpixel2(int i, unsigned char color) {
    virt[i & BMOD] = palette[color];
}

void flip () {
    int y, x, c;
    int *from, *to;

    SDL_LockSurface(screen);
    to = (int*)screen->pixels;
    from = (int*)virt;
    for(y = 0 ; y < 400 ; y++) {
        for (x = 0 ; x < 640 ; x++) {
            c = from[x];
            to[x] = palette[c & 255];
      }
        from += 640;
        to += screen->pitch / 4;
    }

    SDL_UnlockSurface(screen);
    SDL_Flip(screen);
}

void cls() {
    memset(virt, 0, sizeof(int) * BUFFER_SIZE);
}
]])
===
include
