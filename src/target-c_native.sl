;;;
;;; Macros for Forth in SL C Native version
;;;
;;; Copyright (c) 2015-2018 Matti Vesa
;;;

#vars

: program
"#ifdef EMSCRIPTEN" _println
"    #include <emscripten/emscripten.h>" _println
"#endif" _println
"#include <SDL/SDL.h>" _println
"#include <math.h>" _println
"#include <stdio.h>" _println
"#include <stdlib.h>" _println
"#include <string.h>" _println
"#define MAX_STACK 100" _println
"#define BLOCK_SIZE 512 * 512" _println
"#define BMOD BLOCK_SIZE - 1" _println
"#define HEAP_SIZE 1024 * 1024 * 16" _println
"int ds[MAX_STACK]; // data stack" _println
"int ps[MAX_STACK]; // param stack" _println
"int rs[MAX_STACK]; // return stack" _println
"int ts[MAX_STACK]; // temp stack" _println
"int sp;            // data stack pointer" _println
"int psp;           // paramter stack pointer" _println
"int rssp;          // return stack pointer" _println
"int tsp;           // temporary stack pointer" _println
"int tmp;" _println
"int palette[256];" _println
"int * virt;" _println
"int * heap;" _println
"char * strPtr;" _println
"int hp;" _println
"SDL_Surface * screen;" _println
"#ifndef EMSCRIPTEN" _println
"int checkEsc() {" _println
"   Uint8 * KeyState;" _println
"   SDL_PumpEvents();" _println
"   KeyState=SDL_GetKeyState(NULL);" _println
"   return KeyState[SDLK_ESCAPE];" _println
"}" _println
"void Render_Frame();" _println
"void Main_Loop() {" _println
"    do {" _println
"        SDL_Delay(10);" _println
"        Render_Frame();" _println
"    } while (!checkEsc());" _println
"}" _println
"#endif" _println
"int allocMem(int amount) {" _println
"    int oldhp = hp;" _println
"    hp = hp + amount;" _println
"    return oldhp;" _println
"}" _println
"int paramPop() {" _println
"    psp--;" _println
"    return ps[psp + 1];" _println
"}" _println
"void paramPush(int value) {" _println
"    psp++;" _println
"    ps[psp] = value;" _println
"}" _println
"int tempPop() {" _println
"    tsp--;" _println
"    return ts[tsp + 1];" _println
"}" _println
"void tempPush(int value) {" _println
"    tsp++;" _println
"    ts[tsp] = value;" _println
"}" _println

: end-program
;;; TODO check stack here
"#ifndef EMSCRIPTEN" _println
"    free(heap);" _println
"    free(virt);" _println
"#endif" _println
"    return 0;" _println
"}" _println

: main
"int main(int argc, const char* argv[]) {" _println
"    sp = 0;" _println
"    psp = 0;" _println
"    hp = 0;" _println
"    rssp = 0;" _println
"    heap = calloc(HEAP_SIZE, sizeof(int));" _println
"    if(SDL_Init(SDL_INIT_VIDEO)==-1) {" _println
"        printf(\"Could not initialize SDL!\\n\");" _println
"        exit(-1);" _println
"     }" _println
"    atexit(SDL_Quit);" _println
"     if((screen=SDL_SetVideoMode(640, 480, 32, SDL_SWSURFACE|SDL_DOUBLEBUF)) == NULL) {" _println
"       printf(\"Could not set video mode\");" _println
"       exit(-1);" _println
"    }" _println
"    virt = (int*)malloc(BLOCK_SIZE * sizeof(int));" _println

;;; Function definition fun <name> -> <body> fend
: fun "void " _print
: fun-> _print "() {" _println
: fun-fend "}" _println

;;; Function invocation
: (
: ) _print "();" _println

;;; Variable definition
: vars "int GA, GB, GC, GD, GE, GF, GG, GH, GI, GJ, GK, GL, GM, GN;" _println
: | "int" _print _print ";" _println
: endvars

;;; Variable read
: [
: ]

;;; Variable write
: {
: }  _print "=" _print _print ";" _println

;;; Parameters
: p> "paramPop()"
: >p "paramPush(" _print _print ");" _println

;;; Temporaries
: t> "tempPop()"
: >t "tempPush("  _print _print ");" _print

;;; Heap access
: @ " + " _swap _cat _cat "heap[" _swap _cat "]" _cat
: ! "heap[" _print _print "+" _print _print "]=" _print _print ";" _println

;;; Arithmetic
;;; A B op - "("AopB")"
: binop _swap ")" _cat _cat _cat "(" _swap _cat
: + "+" binop
: - "-" binop
: * "*" binop
: / "/" binop
: >> ">>" binop
: << "<<" binop
: mod "%" binop
: and "&" binop
: or "|" binop
: xor "^" binop

;;; Trigonometric functions
: sin  "((int)(sin(" _swap _cat " * M_PI / 512.0) * 256))" _cat
: cos  "((int)(cos(" _swap _cat " * M_PI / 512.0) * 256))" _cat
: atan "((int)(atan(" _swap _cat " / 256.0) * 256))" _cat

;;; Comparisons
: < "<" binop
: > ">" binop
: = "==" binop
: != "!=" binop
: <= "<=" binop
: >= ">=" binop

;;; Conditionals
: if "if (" _print _print ") {" _println
: else "} else {" _println
: endif "}" _println

;;; Looping constructs
: do
    _swap
    "rssp += 2; rs[rssp - 1] = " _print _print ";" _println
    "rs[rssp] = " _print _print ";" _println
    "for ( ; rs[rssp] <= rs[rssp - 1] ; rs[rssp] ++ ) {" _println
: loop "} rssp -= 2;" _println
: i "rs[rssp]"
: j "rs[rssp - 2]"
: k "rs[rssp - 4]"
: repeat "do {" _println
: until "} while ("  _print _print ");" _println
;;; TODO for var do: endfor loops

;;; Stack manipulation
: swap _swap
: dup _dup
: rot _rot
: drop _drop


;;; I/O
: check-esc "checkEsc()"

;;; Memory management
: allot "allocMem(" _swap _cat ")" _cat

;;; Strings
: str-cat
    strPtr = malloc(strlen(ds[sp]) + strlen(ds[sp - 1]) + 1);
    strcpy(strPtr, ds[sp - 1]);
    strcat(strPtr, ds[sp]); bo
    sp--; ds[sp] = strPtr;
: str-free free(ds[sp]); sp--;

;;; STDIO
: print "printf((char*)" _print _print ");" _println
: println "printf((char*)" _print _print ");" _println "_printf(\"\n\");" _println
: read
  getline(strPtr, 0, stdin); sp++; ds[sp] = strPtr;
  
;;; Logical component ;;;



===
