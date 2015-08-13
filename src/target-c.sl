;;;
;;; Macros for Forth in SL C stack version
;;;
;;; Copyright (c) 2015 Matti Vesa
;;;

$target-common

*** program

#include <SDL/SDL.h>
#include <math.h>
#include <stdio.h>
#include <string.h>

#define MAX_STACK 100

#define BLOCK_SIZE 256 * 256
#define BMOD BLOCK_SIZE - 1
#define HEAP_SIZE 1024 * 1024 * 4

int ds[MAX_STACK]; // data stack
int ps[MAX_STACK]; // param stack
int rs[MAX_STACK]; // return stack
int ts[MAX_STACK]; // temp stack
int sg[MAX_STACK]; // stack guard stack
int sp;            // data stack pointer
int psp;           // paramter stack pointer
int rssp;          // return stack pointer
int tsp;           // temporary stack pointer
int tmp;
int palette[256];
int * virt;
int * heap;
char * strPtr;
int hp;
SDL_Surface * screen;

int checkEsc() {

   Uint8 * KeyState;

   SDL_PumpEvents();
   KeyState=SDL_GetKeyState(NULL);

   return KeyState[SDLK_ESCAPE];
}

*** end-program
    free(heap);
    free(virt);
    return;
}


*** main
void main() {
    sp = 0;
    psp = 0;
    hp = 0;
    rssp = 0;
    sgsp = 0;
    heap = malloc(HEAP_SIZE * sizeof(int));
    if(SDL_Init(SDL_INIT_VIDEO)==-1) {
        printf("Could not initialize SDL!\n");
        exit(-1);
     }

     atexit(SDL_Quit);

     if((screen=SDL_SetVideoMode(640, 480, 32, SDL_HWSURFACE|SDL_DOUBLEBUF)) == NULL) {
        printf("Could not set video mode");
        exit(-1);
     }
     virt = (int*)malloc(BLOCK_SIZE * sizeof(int));

;;; Function definition func <name> -> <body> ;
*** :
void
*** ->
() {
*** ;
}

;;; Function invocation
*** (

*** )
();

;;; Variable definition
*** vars
int A, B, C, D, E, F, G, H;

*** var
    int
*** |
;
*** endvars

;;; Variable read
*** [
sp++; ds[sp] =
*** ]
;

;;; Variable write
*** {

*** }
 = ds[sp]; sp--;

;;; Parameters
*** p>
    sp++; ds[sp] = ps[psp]; psp--;
*** >p
    psp++; ps[psp] = ds[sp]; sp--;

;;; Temporaries
*** t>
    tsp++; ts[tsp] = ds[sp]; sp--;
*** >t
    sp++; ds[sp] = ts[tsp]; tsp--;
;;; Literals
*** literal-prolog
    sp++; ds[sp] =
*** literal-epilog
    ;

;;; Heap access
*** @
    ds[sp - 1] = heap[ds[sp] + ds[sp - 1]];
    sp--;
*** !
    heap[ds[sp] + ds[sp - 1]] = ds[sp - 2]; sp -= 3;

;;; Arithmetic
*** +
    ds[sp - 1] = ds[sp - 1] + ds[sp]; sp--;
*** -
    ds[sp - 1] = ds[sp - 1] - ds[sp]; sp--;
*** *
    ds[sp - 1] = ds[sp - 1] * ds[sp]; sp--;
*** /
    ds[sp - 1] = ds[sp - 1] / ds[sp]; sp--;
*** /mod
    tmp = ds[sp]; ds[sp] = ds[sp - 1] / tmp; ds[sp - 1] = ds[sp - 1] % tmp;
*** and
    ds[sp - 1] = ds[sp - 1] & ds[sp]; sp--;
*** or
    ds[sp - 1] = ds[sp - 1] | ds[sp]; sp--;
*** xor
    ds[sp - 1] = ds[sp - 1] ^ ds[sp]; sp--;

;;; Stack management
*** dup
    sp++; ds[sp] = ds[sp - 1];
*** drop
    sp--;
*** pick
    sp++; ds[sp] = ds[sp - 2];
*** tuck
    TODO tuck
*** rot
    TODO rot
*** swap
    tmp = ds[sp]; ds[sp] = ds[sp-1]; ds[sp-1] = tmp;
;;; Trigonometric functions
*** sin
    ds[sp] = sin(ds[sp] * M_PI / 512.0) * 256;
*** cos
    ds[sp] = cos(ds[sp] * M_PI / 512.0) * 256;
*** atan
    ds[sp] = atan(ds[sp] / 256.0) * 256;

;;; Comparisons
*** <
    ds[sp - 1] = ds[sp - 1] < ds[sp]; sp--;
*** >
    ds[sp - 1] = ds[sp - 1] > ds[sp]; sp--;
*** =
    ds[sp - 1] = ds[sp - 1] == ds[sp]; sp--;
*** #
    ds[sp - 1] = ds[sp - 1] != ds[sp]; sp--;
*** <=
    ds[sp - 1] = ds[sp - 1] <= ds[sp]; sp--;
*** >=
    ds[sp - 1] = ds[sp - 1] >= ds[sp]; sp--;
;;; Conditionals
*** if
    sp--;
    if (ds[sp + 1] != 0) {
    
*** endif
    }

;;; Looping constructs
*** do
    rssp += 2; rs[rssp - 1] = ds[sp - 1]; rs[rssp] = ds[sp]; sp -= 2;
    for ( ; rs[rssp] <= rs[rssp - 1] ; rs[rssp] ++ ) {

*** loop
    } rssp -= 2;

*** i
    sp++; ds[sp] = rs[rssp];
*** j
    sp++; ds[sp] = rs[rssp - 2];
*** repeat
    do {

*** until
    sp--; } while (ds[sp + 1] == 0);
    
;;; I/O
*** check-esc
    sp++; ds[sp] = checkEsc();

;;; Memory management
*** allot
    tmp = ds[sp]; ds[sp] = hp; hp += tmp;

;;; Strings
*** str-pre
sp++; ds[sp]="
*** str-post
";
*** str-cat
    strPtr = malloc(strlen(ds[sp]) + strlen(ds[sp - 1]) + 1);
    strcpy(strPtr, ds[sp - 1]);
    strcat(strPtr, ds[sp]);
    sp--; ds[sp] = strPtr;

*** str-free
    free(ds[sp]); sp--;

;;; STDIO
*** print
    printf((char*)ds[sp]);
*** println
    printf((char*)ds[sp]);
    printf("\n");
*** read
    getline(strPtr, 0, stdin); sp++; ds[sp] = strPtr;

===