;;;
;;; x86 16bit real mode target
;;;
;;; Copyright 2015-2018 (c) Matti Vesa
;;;

$target-common
$target-common.blocks

  '_reg-index _19
  '_label-index _21
  '_label-count _20

: _load-reg-index _reg-index _aload
: _store-reg-index _reg-index _astore
: _pop-reg
  _load-reg-index _1 _sub _store-reg-index
: _push-reg
  _load-reg-index _1 _add _store-reg-index
: _get-TOS
  _reg-index _aload _aload
: _get-NOS
  _reg-index _aload _1 _sub _aload
: _get-3rd
  _reg-index _aload _2 _sub _aload
: _get-4th
  _reg-index _aload _3 _sub _aload
: _gen-label
  _label-index _aload _1 _add _label-index _astore
  _label-count _aload _1 _add _label-count _astore
  "label" _label-count _aload _cat
  _label-index _aload _label-index _add _astore
: _get-last-label
  _label-index _aload _label-index _add _aload
: _pop-label
  _label-index _aload _1 _sub _label-index _astore
===
  ;;; Initialize indexes
  _0 _reg-index _astore
  _1 _label-index _astore
  _1 _label-count _astore

  "dx" _0 _astore
  "bp" _1 _astore
  "si" _2 _astore
  "di" _3 _astore
  "[stack1]" _4 _astore
  "[stack2]" _5 _astore
  "[stack3]" _6 _astore
  "[stack4]" _7 _astore
  "[stack5]" _8 _astore
  "[stack6]" _9 _astore
  "[stack7]" _10 _astore
  "[stack8]" _11 _astore
  "[stack9]" _12 _astore
  "[stackA]" _13 _astore
  "[stackB]" _14 _astore
  "[stackC]" _15_astore
  "[stackD]" _16_astore
  "[stackE]" _17_astore
  "[stackF]" _18 _astore

: program

  "org 0100h" _println
  "mov ax, 13h" _println
  "int 10h" _println
  "xor ax, ax" _println
  "int 33h" _println
  "push 0a000h" _println
  "pop es" _println
  "jmp main" _println
  "SINTAB equ 16384" _println
  "A dw 0" _println
  "B dw 0" _println
  "C dw 0" _println
  "D dw 0" _println
  "E dw 0" _println
  "F dw 0" _println
  "G dw 0" _println
  "H dw 0" _println
  "I dw 0" _println
  "J dw 0" _println
  "K dw 0" _println
  "L dw 0" _println
  "M dw 0" _println
  "GA dw 0" _println
  "stack1 dw 0" _println
  "stack2 dw 0" _println
  "stack3 dw 0" _println
  "stack4 dw 0" _println
  "stack5 dw 0" _println
  "stack6 dw 0" _println
  "stack7 dw 0" _println
  "stack8 dw 0" _println
  "stack9 dw 0" _println
  "stackA dw 0" _println
  "stackB dw 0" _println
  "stackC dw 0" _println
  "stackD dw 0" _println
  "stackE dw 0" _println
  "stackF dw 0" _println
  "temp1 dw 0" _println
  "temp2 dw 0" _println
  "temp3 dw 0" _println
  "heap  dw 0x5000" _println
  "params dw 32768 ;32k of code for now" _println

: end-program
  "mov ax,3h" _println
  "int 10h" _println
  "ret" _println

;;; Function invocation
: (
: )
  "call " _print _println

;;; Function declaration
: fun
: fun->
 _print ":" _println

: fun-fend
  "ret" _println

;;; heap
: allot
  "mov ax, [heap]" _println
  "xchg " _print _get-TOS _print ", ax" _println
  "shr ax, 3" _println
  "inc ax" _println
  "add [heap], ax" _println
: @
  "mov es, " _print _get-TOS _println
  "mov bx, " _print _get-NOS _println
  "shl bx, 1" _println
  "mov ax, [es:bx]" _println
  "mov " _print _get-NOS _print ",ax" _println
  _pop-reg
: !
  "mov es, " _print _get-TOS _println
  "mov bx, " _print  _get-NOS _println
  "shl bx, 1" _println
  "mov ax, " _print  _get-3rd _println
  "mov [es:bx], ax" _println
  _pop-reg _pop-reg _pop-reg

;;; Iteration constructions
: do
  "push cx" _println
  "mov cx, " _print _get-TOS _println
  "push word " _print _get-NOS _println
  _gen-label _get-last-label _print ":" _println
  _pop-reg _pop-reg

: loop
  "inc cx" _println
  "mov bx, sp" _println
  "cmp [ss:bx], cx" _println
  "jge " _print _get-last-label _println
  "pop cx" _println
  "pop cx" _println
  _pop-label

: i
  _push-reg
  "mov " _print _get-TOS _print ", cx" _println

: j
  _push-reg
  "mov bx, sp" _println
  "mov ax, [ss:bx + 2]" _println
  "mov " _print _get-TOS _print ", ax" _println

: k
  _push-reg
  "mov bx, sp" _println
  "mov ax, [ss:bx + 4]" _println
  "mov " _print _get-TOS _print ", ax" _println

: repeat
  _gen-label _get-last-label _print ":" _println

: until
  "cmp " _print _get-TOS _print ",0" _println
  "je " _print _get-last-label _println
  _pop-label _pop-reg

;;; Conditionals
: if
  "cmp word " _print _get-TOS _print ", 0" _println
  "je " _print _gen-label _get-last-label _println
  _pop-reg

: endif
  _get-last-label _print ":" _println
  _pop-label


: check-esc
  _push-reg
  "xor ax,ax" _println
  "in al, 60h" _println
  "dec al" _println
  "not al" _println
  "mov " _print _get-TOS _print ", ax" _println

;;; Comparisons
: <
  "mov ax, " _print _get-NOS _println
  "cmp ax, " _print _get-TOS _println
  "setl al" _println
  "xor ah,ah" _println
  "mov " _print _get-NOS _print ", ax" _println
  _pop-reg

: >
  "mov ax, " _print _get-NOS _println
  "cmp ax, " _print _get-TOS _println
  "setg al" _println
  "xor ah,ah" _println
  "mov " _print _get-NOS _print ", ax" _println
  _pop-reg

: =<
  "mov ax, " _print _get-NOS _println
  "cmp ax, " _print _get-TOS _println
  "setle al" _println
  "xor ah,ah" _println
  "mov " _print _get-NOS _print ", ax" _println
  _pop-reg

: >=
  "mov ax, " _print _get-NOS _println
  "cmp ax, " _print _get-TOS _println
  "setge al" _println
  "xor ah,ah" _println
  "mov " _print _get-NOS _print ", ax" _println
  _pop-reg

: _literal-number
  _push-reg
  "mov word " _print _get-TOS _print "," _print _println

;;; Arithmetic
: +
  "mov ax, " _print _get-TOS _println
  "add " _print _get-NOS _print  ", ax" _println
  _pop-reg

: -
  "mov ax, " _print _get-TOS _println
  "sub " _print _get-NOS _print  ", ax" _println
  _pop-reg

: *
  "mov ax, " _print _get-NOS _println
  "mov bx, dx" _println
  "imul word " _print _get-TOS _println
  "mov dx, bx" _println
  "mov " _print _get-NOS _print ",ax" _println
  _pop-reg

: /
  "mov ax, " _print _get-NOS _println
  "mov bx, dx" _println
  "cwd" _println
  "idiv word " _print _get-TOS _println
  "mov dx, bx" _println
  "mov " _print _get-NOS _print ",ax" _println
  _pop-reg

;;; Trigonometric functions
: sin
  "mov bx, " _print _get-TOS _println
  "shl bx, 1" _println
  "mov ax, [SINTAB+bx]" _println
  "mov " _print _get-TOS _print ", ax" _println

: cos
  "mov bx, " _print _get-TOS _println
  "shl bx, 1" _println
  "mov ax, [SINTAB+256+bx]" _println
  "mov " _print _get-TOS _print ", ax" _println

;;; Boolean ops
: and
  "mov ax, " _print _get-TOS _println
  "and " _print _get-NOS _print ", ax" _println
  _pop-reg

: or
  "mov ax, " _print _get-TOS _println
  "or " _print _get-NOS _print ", ax" _println
  _pop-reg

: xor
  "mov ax, " _print _get-TOS _println
  "xor " _print _get-NOS _print ", ax" _println
  _pop-reg

;;; Variable definition
: vars
: var
: | _print " dw 0" _println
: endvars

;;; Variable access
: {
: }
  "mov ax, " _print _get-TOS _println
  "mov [" _print _print "],ax" _println
  _pop-reg
: [
: ]
  _push-reg
  "mov ax,[" _print _print "]" _println
  "mov " _print _get-TOS _print ", ax" _println

;;; Stack manipulation
;;; : swap _swap
;;; : dup _dup
;;; : drop _drop


: swap
  "mov ax, " _print _get-TOS _println
  "xchg ax, " _print _get-NOS _println
  "mov " _print _get-TOS _print ", ax" _println
: dup
  _push-reg
  "mov ax, " _print _get-NOS _println
  "mov " _print _get-TOS _print ", ax" _println
: drop
  _pop_reg

;;; Temporary Stack
: >t
  "push word " _print _get-TOS _println
  _pop-reg

: t>
  _push-reg
  "pop word " _print _get-TOS _println

;;; Parameter stack
: >p
  "mov bx, [params]" _println
  "mov ax, " _print _get-TOS _println
  "mov [bx], ax" _println
  "add word [params], 2" _println
  _pop-reg

: p>
  _push-reg
  "mov bx, [params]" _println
  "mov ax, [bx - 2]" _println
  "mov " _print _get-TOS _print ", ax" _println
  "sub word [params], 2" _println

;;; Various entry points
: main
  "main:" _println
  "  xor bx,bx    ;sin" _println
  "  mov ch,63    ;cos" _println
  "  mov bp,402   ;frq" _println
  "  xor di,di" _println
  "SinLoop:" _println
  "  mov ax,cx" _println
  "  imul bp" _println
  "  test di,1" _println
  "  jnz Skip" _println
  "  mov ax,cx" _println
  "  sar ax,6" _println
  "  mov [di + SINTAB],ax" _println
  "  neg dx" _println
  "Skip:" _println
  "  add bx,dx" _println
  "  xchg bx,cx" _println
  "  inc di" _println
  "  cmp di,2048+512 ; 512 more angles to acommodate cos" _println
  "  jb SinLoop" _println

: enter-rendering-loop
  "render_loop:" _println
  "  call Render_Frame" _println
  "  in al,60h" _println
  "  cmp al,1" _println
  "  jne render_loop" _println

: get-mouse
  "push dx" _println
  "mov ax, 3h"  _println
  "int 33h"  _println
  "shr cx, 1"  _println
  "mov [temp1], cx"  _println
  "mov [temp2], dx"  _println
  "mov [temp3], bx"  _println
  "pop dx"  _println
  _push-reg
  "mov " _print _get-TOS _print ", [temp3]" _println
  _push-reg
  "mov " _print _get-TOS _print ", [temp2]" _println
  _push-reg
  "mov " _print _get-TOS _print ", [temp1]" _println
===