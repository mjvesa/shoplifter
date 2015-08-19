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

    local regs = {[0] = "dx", "bp", "si", "di", "stack1", "stack2", "stack3", "stack4", "stack5"}
    local sp = -1

    print([[org 0100h
           mov ax, 13h
           int 10h
           xor ax, ax
           int 33h
           push 0a000h
           pop es
           jmp main
           stack1 dw 0
           stack2 dw 0
           stack3 dw 0
           stack4 dw 0
           stack5 dw 0
           temp1 dw 0
           temp2 dw 0
           temp3 dw 0
           heap  dw 0x5000
           params dw 32768 ;32k of code for now
           main:]])

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
    sp = sp + 1
    print("mov ax, heap")
    print("xchg " .. regs[sp] .. ", ax");
    print("shr ax, 4")
    print("inc ax")
    print("add heap, ax")

*** @
    print("mov es, " .. regs[sp])
    print("mov bx, " .. regs[sp - 1])
    print("shl bx, 1")
    print("mov " .. regs[sp - 1] .. ", es:[bx]")
    sp = sp - 1

*** !
    print("mov es, " .. regs[sp])
    print("mov bx, " .. regs[sp - 1])
    print("shl bx, 1")
    print("mov ax, " .. regs[sp - 2])
    print("mov es:[bx], ax")
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
    print("mov " .. regs[sp] .. ", [ss:bx + 2]")

*** repeat
    print(genLabel() .. ":")

*** until
    print("cmp " .. regs[sp] .. ",0")
    print("je " .. lastLabel())
    dropLabel()
    sp = sp - 1

;;; Conditionals
*** if
    print("cmp " .. regs[sp] ..", 0")
    print("je " .. genLabel())

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
    print("xor ax, ax")
    print("cmp " .. regs[sp] .. ", " .. regs[sp - 1])
    print("setl al")
    print("mov " .. regs[sp] .. ", ax")
    sp = sp - 1
*** >
    print("xor ax, ax")
    print("cmp " .. regs[sp] .. ", " .. regs[sp - 1])
    print("setg al")
    print("mov " .. regs[sp] .. ", ax")
    sp = sp - 1

*** <=
    print("xor ax, ax")
    print("cmp " .. regs[sp] .. ", " .. regs[sp - 1])
    print("setle al")
    print("mov " .. regs[sp] .. ", ax")
    sp = sp - 1

*** >=
    print("xor ax, ax")
    print("cmp " .. regs[sp] .. ", " .. regs[sp - 1])
    print("setge al")
    print("mov " .. regs[sp] .. ", ax")
    sp = sp - 1


*** literal-prolog
    sp = sp + 1
    print("mov " .. regs[sp] .. ",
*** literal-epilog
")


;;; Arithmetic
*** +
    print("add " .. regs[sp - 1] .. "," .. regs[sp])
    sp = sp - 1

*** -
    print("sub " .. regs[sp - 1] .. "," .. regs[sp])
    sp = sp - 1

*** *
    print("mov ax, " .. regs[sp - 1])
    print("mov bx, dx")
    print("imul " .. regs[sp])
    print("mov dx, bx")
    print("mov " .. regs[sp - 1] .. ",ax")
    sp = sp - 1

*** /
    print("mov ax, " .. regs[sp - 1])
    print("mov bx, dx")
    print("cwd")
    print("idiv " .. regs[sp])
    print("mov dx, bx")
    print("mov " .. regs[sp - 1] .. ",ax")
    sp = sp - 1

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
    print("mov
*** }
," .. regs[sp])
    sp = sp - 1

*** [
    sp = sp + 1
    print("mov " .. regs[sp] .. ",
*** ]
")

;;; Stack manipulation
*** swap
    print("mov ax, " .. regs[sp])
    print("xchg ax, " .. regs[sp - 1])
    print("mov " .. regs[sp] .. ", ax")

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

;;; Stack manipulation
*** dup
    sp = sp + 1
    print("mov " .. regs[sp] .. ", " .. regs[sp - 1])
*** drop
    sp = sp - 1

;;; Temporary Stack
*** >t
    print("push " .. regs[sp])
    sp = sp - 1

*** t>
    sp = sp + 1
    print("pop " .. regs[sp])

;;; Parameter stack
*** >p
    print("mov bx, params")
    print("mov [bx], " .. regs[sp])
    print("add params, 2")
    sp = sp - 1

*** p>
    sp = sp + 1
    print("mov bx, params")
    print("mov ax, [params - 2]")
    print("mov " .. regs[sp] .. ", ax")

*** enter-rendering-loop


===

