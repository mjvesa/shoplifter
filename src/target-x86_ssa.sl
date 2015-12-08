;;;
;;; x86 real mode target
;;;
;;; Copyright 2015 (c) Matti Vesa
;;;

$target-common

*** program
    local labels = {}
    local labelP = -1
    local labelCounter = 0

    local regs = {[0] = "dx", "bp", "si", "di", "[stack1]", "[stack2]", "[stack3]", "[stack4]",
                  "[stack5]", "[stack6]", "[stack7]", "[stack8]", "[stack9]", "[stackA]", "[stackB]",
                  "[stackC]", "[stackD]", "[stackE]", "[stackF]"}
    local sp = -1

    print([[
           org 0100h
           mov ax, 13h
           int 10h
           xor ax, ax
           int 33h
           push 0a000h
           pop es
           jmp main
           SINTAB equ 16384
           A dw 0
           B dw 0
           C dw 0
           D dw 0
           E dw 0
           F dw 0
           G dw 0
           H dw 0
           I dw 0
           J dw 0
           stack1 dw 0
           stack2 dw 0
           stack3 dw 0
           stack4 dw 0
           stack5 dw 0
           stack6 dw 0
           stack7 dw 0
           stack8 dw 0
           stack9 dw 0
           stackA dw 0
           stackB dw 0
           stackC dw 0
           stackD dw 0
           stackE dw 0
           stackF dw 0
           temp1 dw 0
           temp2 dw 0
           temp3 dw 0
           heap  dw 0x5000
           params dw 32768 ;32k of code for now]])

    function genLabel()
        labelCounter = labelCounter + 1
        labelP = labelP + 1
        local newLabel = "l" .. labelCounter
        labels[labelP] = newLabel
        return newLabel
    end

    function lastLabel()
        return labels[labelP]
    end

    function dropLabel()
        labelP = labelP - 1
    end

*** end-program
    print("ret")

;;; Function invocation
*** (
    print("call 
*** )
")
;;; Function declaration
*** :
print("
*** ->
:")

*** ;
    print("ret")

;;; heap
*** allot
    print("mov ax, [heap]")
    print("xchg " .. regs[sp] .. ", ax");
    print("shr ax, 3")
    print("inc ax")
    print("add [heap], ax")

*** @
    print("mov es, " .. regs[sp])
    print("mov bx, " .. regs[sp - 1])
    print("shl bx, 1")
    print("mov ax, [es:bx]")
    print("mov " .. regs[sp - 1] .. ",ax")
    sp = sp - 1

*** !
    print("mov es, " .. regs[sp])
    print("mov bx, " .. regs[sp - 1])
    print("shl bx, 1")
    print("mov ax, " .. regs[sp - 2])
    print("mov [es:bx], ax")
    sp = sp - 3

;;; Iteration constructions
*** do
    print("push cx")
    print("mov cx, " .. regs[sp])
    print("push " .. regs[sp - 1])
    print(genLabel() .. ":")
    sp = sp - 2

*** loop
    print("inc cx")
    print("mov bx, sp")
    print("cmp [ss:bx], cx")
    print("jge " .. lastLabel())
    print("pop cx")
    print("pop cx")
    dropLabel()

*** i
    sp = sp + 1
    print("mov " .. regs[sp] .. ", cx")

*** j
    sp = sp + 1
    print("mov bx, sp")
    print("mov ax, [ss:bx + 2]")
    print("mov " .. regs[sp] .. ", ax")

*** k
    sp = sp + 1
    print("mov bx, sp")
    print("mov ax, [ss:bx + 4]")
    print("mov " .. regs[sp] .. ", ax")

*** repeat
    print(genLabel() .. ":")

*** until
    print("cmp " .. regs[sp] .. ",0")
    print("je " .. lastLabel())
    dropLabel()
    sp = sp - 1

;;; Conditionals
*** if
    print("cmp word " .. regs[sp] ..", 0")
    print("je " .. genLabel())
    sp = sp - 1

*** endif
    print(lastLabel() .. ":")
    dropLabel()

*** check-esc
    sp = sp + 1
    print("xor ax,ax")
    print("in al, 60h")
    print("dec al")
    print("not al")
    print("mov " .. regs[sp] .. ", ax")

;;; Comparisons
*** <
    print("mov ax, " .. regs[sp - 1])
    print("cmp ax, " .. regs[sp])
    print("setl al")
    print("xor ah,ah")
    print("mov " .. regs[sp - 1] .. ", ax")
    sp = sp - 1
*** >
    print("mov ax, " .. regs[sp - 1])
    print("cmp ax, " .. regs[sp])
    print("setg al")
    print("xor ah,ah")
    print("mov " .. regs[sp - 1] .. ", ax")
    sp = sp - 1

*** <=
    print("mov ax, " .. regs[sp - 1])
    print("cmp ax, " .. regs[sp])
    print("setle al")
    print("xor ah,ah")
    print("mov " .. regs[sp - 1] .. ", ax")
    sp = sp - 1

*** >=
    print("mov ax, " .. regs[sp - 1])
    print("cmp ax, " .. regs[sp])
    print("setge al")
    print("xor ah,ah")
    print("mov " .. regs[sp - 1] .. ", ax")
    sp = sp - 1

*** literal-prolog
    sp = sp + 1
    print("mov word " .. regs[sp] .. ",
*** literal-epilog
")


;;; Arithmetic
*** +
    print("mov ax, " .. regs[sp])
    print("add " .. regs[sp - 1] .. ", ax")
    sp = sp - 1

*** -
    print("mov ax, " .. regs[sp])
    print("sub " .. regs[sp - 1] .. ",ax")
    sp = sp - 1

*** *
    print("mov ax, " .. regs[sp - 1])
    print("mov bx, dx")
    print("imul word " .. regs[sp])
    print("mov dx, bx")
    print("mov " .. regs[sp - 1] .. ",ax")
    sp = sp - 1

*** /
    print("mov ax, " .. regs[sp - 1])
    print("mov bx, dx")
    print("cwd")
    print("idiv word " .. regs[sp])
    print("mov dx, bx")
    print("mov " .. regs[sp - 1] .. ",ax")
    sp = sp - 1

;;; Trigonometric functions
*** sin
    print("mov bx, " .. regs[sp])
    print("shl bx, 1")
    print("mov ax, [SINTAB+bx]")
    print("mov " .. regs[sp] .. ", ax")
*** cos
    print("mov bx, " .. regs[sp])
    print("shl bx, 1")
    print("mov ax, [SINTAB+256+bx]")
    print("mov " .. regs[sp] .. ", ax")

;;; Boolean ops
*** and 
    print("mov ax, " .. regs[sp])
    print("and " .. regs[sp - 1] .. ", ax")
    sp = sp - 1

*** or
    print("mov ax, " .. regs[sp])
    print("or " .. regs[sp - 1] .. ", ax")
    sp = sp - 1

*** xor
    print("mov ax, " .. regs[sp])
    print("xor " .. regs[sp - 1] .. ", ax")
    sp = sp - 1

;;; Variable definition
*** vars
*** var
    print("
*** |
 dw 0")
*** endvars

;;; Variable access
*** {
    print("mov ax, " .. regs[sp])
    print("mov [
*** }
],ax")
    sp = sp - 1

*** [
    sp = sp + 1
    print("mov ax,[
*** ]
]")
    print("mov " .. regs[sp] .. ", ax")

;;; Stack manipulation
*** swap
    print("mov ax, " .. regs[sp])
    print("xchg ax, " .. regs[sp - 1])
    print("mov " .. regs[sp] .. ", ax")

*** dup
    sp = sp + 1
    print("mov ax, " .. regs[sp - 1])
    print("mov " .. regs[sp] .. ", ax")
*** drop
    sp = sp - 1

;;; Temporary Stack
*** >t
    print("push word " .. regs[sp])
    sp = sp - 1

*** t>
    sp = sp + 1
    print("pop word " .. regs[sp])

;;; Parameter stack
*** >p
    print("mov bx, [params]")
    print("mov ax, " .. regs[sp])
    print("mov [bx], ax")
    print("add word [params], 2")
    sp = sp - 1

*** p>
    sp = sp + 1
    print("mov bx, [params]")
    print("mov ax, [bx - 2]")
    print("mov " .. regs[sp] .. ", ax")
    print("sub word [params], 2")

;;; Various entry points
*** main
    print([[
           main:
           xor bx,bx    ;sin
           mov ch,63    ;cos
           mov bp,402   ;frq
           xor di,di
SinLoop:
           mov ax,cx
           imul bp
           test di,1
           jnz Skip
           mov ax,cx
           sar ax,6
           mov [di + SINTAB],ax
           neg dx
Skip:
           add bx,dx
           xchg bx,cx
           inc di
           cmp di,2048+512 ; 512 more angles to acommodate cos
           jb SinLoop]])

*** enter-rendering-loop
    print([[
render_loop:
    call Render_Frame
    in al,60h
    cmp al,1
    jne render_loop]])


*** get-mouse
    print("push dx")
    print("mov ax, 3h")
    print("int 33h")
    print("shr cx, 1")
    print("mov [temp1], cx")
    print("mov [temp2], dx")
    print("mov [temp3], bx")
    print("pop dx")
    sp = sp + 1
    print("mov " .. regs[sp] .. ", [temp3]")
    sp = sp + 1
    print("mov " .. regs[sp] .. ", [temp2]")
    sp = sp + 1
    print("mov " .. regs[sp] .. ", [temp1]")

===

