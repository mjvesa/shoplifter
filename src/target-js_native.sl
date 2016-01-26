;;;
;;; Macros for Forth in SL JavaScript native version
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
        push("((" .. left .. "|0)" .. op .. "(".. right .. "|0))")
    end

print([[

<html>
    <head><title>Shoplifter program</title></head>
    <body>
        <canvas id="canvas" width="320" height="200" style="width:100%; height:100%;"></canvas>
        <script>
    var ds = [];
    var ps = [];  // param stack
    var rs = [];  // return stack
    var ts =  [];  // temp stack
    var psp = 0;  // paramter stack pointer
    var rssp = 0; // return stack pointer
    var tsp = 0;  // temporary stack pointer
    var sp = 0;
    var tmp;
    var palette = [];
    var virt = [];
    var heap = new Int16Array(65536 * 16);
    var hp = 0;

var Main_Loop = function()  {
     Render_Frame();
     window.requestAnimationFrame(Main_Loop);
}

var allocMem = function(amount) {
    hp = hp + amount;
    return hp;
}

var paramPop = function() {
    psp--;
    return ps[psp + 1];
}

var paramPush = function(value) {
    psp++;
    ps[psp] = value;
}

var tempPop = function() {
    tsp--;
    return ts[tsp + 1];
}

var tempPush = function(value) {
    tsp++;
    ts[tsp] = value;
}
]])


*** end-program
checkStack()
print([[
        </script>
    </body>
</html>
]])

*** main

;;; Function definition fun <name> -> <body> fend
*** fun
print("var
*** fun->
= function() {")

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
print("var A, B, C, D, E, F, G, H, I, J, K, L, M, N;")
*** var
print("var
*** |
;")
*** endvars

;;; Variable read
*** [
push("(
*** ]
|0)")
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
    ds[sp] = "(Math.sin(" .. ds[sp] .. " * Math.PI / 512.0) * 256)|0"
*** cos
    ds[sp] = "(Math.cos(" .. ds[sp] .. " * Math.PI / 512.0) * 256)|0"
*** atan
    ds[sp] = "(Math.atan(" .. ds[sp] .. " / 256.0) * 256)|0"

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
    print("} while (" .. pop() .. " === 0);")
*** enter-rendering-loop
    print("window.requestAnimationFrame(Main_Loop);")

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
    sp--; ds[sp] = ds[sp] + ds[sp + 1];
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
    TODO cls
*** setpal
    print("palette[" .. ds[sp] .. " ] = " .. ds[sp - 1] .. " * 65536 + " .. ds[sp - 2] .. " * 256 + " .. ds[sp - 3] ..";")
    sp = sp - 4

===