;;;
;;; Macros for Forth in SL C Multi Stage version
;;;
;;; Copyright (c) 2015 Matti Vesa
;;;

$target-common

*** program

    local tmp
    local ds = {}
    local sp = -1

    function pop()
        if sp == -1 then
            print("ERROR: Stack undeflow!")
            os.exit()
        else
            sp = sp - 1
            return ds[sp + 1]
        end
    end

    function push(value)
        sp = sp + 1
        ds[sp] = value
    end

    function checkStack()
        if sp > -1 then
            print("ERROR : Stack not empty at end of block! Contents:" )
            for k,v in pairs(ds) do
                print("* " .. k, v)
            end
        end
        sp = -1
    end

    function binop(op)
        local right = pop()
        local left = pop()
        push("(" .. left .. op .. right .. ")")
    end

print([[
#ifdef EMSCRIPTEN
    #include <emscripten/emscripten.h>
#endif
#include <SDL/SDL.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_STACK 100

#define BLOCK_SIZE 512 * 512
#define BMOD BLOCK_SIZE - 1
#define HEAP_SIZE 1024 * 1024 * 16

int ds[MAX_STACK]; // data stack
int ps[MAX_STACK]; // param stack
int rs[MAX_STACK]; // return stack
int ts[MAX_STACK]; // temp stack
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


#ifndef EMSCRIPTEN
int checkEsc() {

   Uint8 * KeyState;

   SDL_PumpEvents();
   KeyState=SDL_GetKeyState(NULL);

   return KeyState[SDLK_ESCAPE];
}

void Render_Frame();

void Main_Loop() {
    do {
        SDL_Delay(10);
        Render_Frame();
    } while (!checkEsc());
}
#endif


int allocMem(int amount) {
    int oldhp = hp;
    hp = hp + amount;
    return oldhp;
}


int paramPop() {
    psp--;
    return ps[psp + 1];
}

void paramPush(int value) {
    psp++;
    ps[psp] = value;
}

int tempPop() {
    tsp--;
    return ts[tsp + 1];
}

void tempPush(int value) {
    tsp++;
    ts[tsp] = value;
}



]])


*** end-program
checkStack()
print([[
#ifndef EMSCRIPTEN
    free(heap);
    free(virt);
#endif
    return 0;
}
]])

*** main
print([[
int main(int argc, const char* argv[]) {
    sp = 0;
    psp = 0;
    hp = 0;
    rssp = 0;
    heap = calloc(HEAP_SIZE, sizeof(int));
    if(SDL_Init(SDL_INIT_VIDEO)==-1) {
        printf("Could not initialize SDL!\n");
        exit(-1);
     }

    atexit(SDL_Quit);

     if((screen=SDL_SetVideoMode(640, 480, 32, SDL_SWSURFACE|SDL_DOUBLEBUF)) == NULL) {
        printf("Could not set video mode");
        exit(-1);
     }
     virt = (int*)malloc(BLOCK_SIZE * sizeof(int));
]])
;;; Function definition func <name> -> <body> ;
*** fun
print("void 
*** fun->
() {")

*** fun-fend
print("}")

checkStack()

;;; Function invocation
*** (
print("
*** )
();")

;;; Variable definition
*** vars
print("int A, B, C, D, E, F, G, H, I, J, K, L, M, N;")
*** var
print("int
*** |
;")
*** endvars

;;; Variable read
*** [
push("
*** ]
")
;;; Variable write
*** {
print("
*** }
 = " .. pop() .. ";")

;;; Parameters
*** p>
    push("paramPop()")
*** >p
    print("paramPush(" .. pop() .. ");")

;;; Temporaries
*** t>
    push("tempPop()")
*** >t
    print("tempPush(" .. pop() .. ");")

;;; Literals
*** literal-prolog
push("
*** literal-epilog
")

;;; Heap access
*** @
    ds[sp - 1] = "heap[" .. ds[sp] .. " + " .. ds[sp - 1] .. "]"
    sp = sp - 1
*** !
    print("heap[".. ds[sp] .. " + " .. ds[sp - 1] .. " ]  = " .. ds[sp - 2] .. ";")
    sp = sp - 3

;;; Arithmetic
*** +
    binop("+")

*** -
    binop("-")

*** *
    binop("*")

*** /
    binop("/")

*** >>
    binop(">>")
*** <<
    binop("<<")
*** mod
    binop("%")
;;; *** /mod
;;; tmp = ds[sp]; ds[sp] = ds[sp - 1] / tmp; ds[sp - 1] = ds[sp - 1] % tmp;


*** and
    binop("&")

*** or
    binop("|")

*** xor
    binop("^")

;;; Stack management
*** dup
    sp = sp + 1
    ds[sp] = ds[sp - 1]

*** drop
    pop()

*** pick
    sp = sp + 1
    ds[sp] = ds[sp - 2]

*** tuck
    TODO tuck
*** rot
    TODO rot
*** swap
    tmp = ds[sp]
    ds[sp] = ds[sp-1]
    ds[sp-1] = tmp

;;; Trigonometric functions
*** sin
    ds[sp] = "((int)(sin(" .. ds[sp] .. " * M_PI / 512.0) * 256))"
*** cos
    ds[sp] = "((int)(cos(" .. ds[sp] .. " * M_PI / 512.0) * 256))"
*** atan
    ds[sp] = "((int)(atan(" .. ds[sp] .. " / 256.0) * 256))"

;;; Comparisons
*** <
    binop("<")

*** >
    binop(">")

*** =
    binop("=")

*** #
    binop("!=")

*** <=
    binop("<=")

*** >=
    binop(">=")

;;; Conditionals
*** if
    print("if (" .. pop() .. " != 0) {")
*** else
    print("} else {")
*** endif
    print("}")
;;; Looping constructs
*** do
    local lower = pop()
    local upper = pop()
    print("rssp += 2; rs[rssp - 1] = " .. upper .. ";")
    print("rs[rssp] = " .. lower .. ";")
    print("for ( ; rs[rssp] <= rs[rssp - 1] ; rs[rssp] ++ ) {")
*** loop
    print("} rssp -= 2;")
*** i
    push("rs[rssp]")
*** j
    push("rs[rssp - 2]")
*** k
    push("rs[rssp - 4]")
*** repeat
    print("do {")
*** until
    print("} while (" .. pop() .. " == 0);")
*** enter-rendering-loop
print([[
#ifdef EMSCRIPTEN
    emscripten_set_main_loop(Render_Frame, 0, 0);
#else
    Main_Loop();
#endif
]])
;;; I/O
*** check-esc
    push("checkEsc()")

;;; Memory management
*** allot
    push("allocMem(" .. pop() .. ")")

;;; Strings
*** str-pre
sp = sp + 1
ds[sp]="
*** str-post
";
*** str-cat
    strPtr = malloc(strlen(ds[sp]) + strlen(ds[sp - 1]) + 1);
    strcpy(strPtr, ds[sp - 1]);
    strcat(strPtr, ds[sp]); bo
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

;;; Graphics for oldskool
*** putpixel
    print("putpixel(" .. ds[sp - 2] .. "," .. ds[sp - 1] .. "," ... ds[sp] .. ");")
    sp = sp - 3
*** putpixel2
    print("putpixel2(" .. ds[sp - 1] .. "," .. ds[sp] .. ");")
    sp = sp - 2
*** flip
    print("flip();")

*** cls
    print("cls();")

*** setpal
    print("palette[" .. ds[sp] .. " ] = " .. ds[sp - 1] .. " * 65536 + " .. ds[sp - 2] .. " * 256 + " .. ds[sp - 3] ..";")
    sp = sp - 4

===