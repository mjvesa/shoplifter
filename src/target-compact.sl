;;;
;;; Macros for Forth in SL C Multi Stage version
;;;
;;; Copyright (c) 2015 Matti Vesa
;;;

$target-common

*** program

    local index=1
    local chars_to_words={}
    local words_to_chars={}
    local chars="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    result = "a"
    words_to_chars["program"] = "a"
    chars_to_words["a"] = "program"

    function peekchar()
        return chars:sub(index,index)
    end

    function encode(word)
        if (words_to_chars[word] == nil) then
            words_to_chars[word] = peekchar()
            chars_to_words[peekchar()] = word
            index = index + 1
        end
        result = result .. words_to_chars[word]
    end

    function trim(str)
        return string.gsub(str , "%s$", "")
    end

*** end-program
    print(result);
    ;;; TODO print map as well

*** main
    encode("main")
;;; Function definition func <name> -> <body> ;

*** fun
    encode("fun")
    encode(trim("
*** fun->
"))
    encode("fun->")

*** fun-fend
    encode("fun-fend")

;;; Function invocation
*** (
    encode("(")
    encode(trim("
*** )
"))
    encode(")")

;;; Variable definition
*** vars
    encode("vars")

*** var
    encode("var")
    encode(trim("
*** |
"))
    encode("|")

*** endvars
    encode("endvars")

;;; Variable read
*** [
    encode("[")
    encode(trim("
*** ]
"))
    encode("]")

;;; Variable write
*** {
    encode("{")
    encode(trim("
*** }
"))
    encode("}")

;;; Parameters
*** p>
    encode("p>")

*** >p
    encode(">p")

;;; Temporaries
*** t>
    encode("t>")

*** >t
    encode(">t")

;;; Literals
*** literal-prolog
    encode("literal-prolog")
    encode(trim("
*** literal-epilog
"))
    encode("literal-epilog")

;;; Heap access
*** @
    encode("@")

*** !
    encode("!")

;;; Arithmetic
*** +
    encode("+")

*** -
    encode("-")

*** *
    encode("*")

*** /
    encode("/")

*** mod
    encode("mod")

;;; *** /mod
;;; tmp = ds[sp]; ds[sp] = ds[sp - 1] / tmp; ds[sp - 1] = ds[sp - 1] % tmp;

*** and
    encode("and")

*** or
    encode("or")

*** xor
    encode("xor")

;;; Stack management
*** dup
    encode("dup")

*** drop
    encode("drop")

*** pick
    encode("pick")

*** tuck
    encode("tuck")

*** rot
    encode("rot")

*** swap
    encode("swap")

;;; Trigonometric functions
*** sin
    encode("sin")

*** cos
    encode("cos")

*** atan
    encode("atan")

;;; Comparisons
*** <
    encode("<")

*** >
    encode(">")

*** =
    encode("=")

*** <>
    encode("#")

*** <=
    encode("<=")

*** >=
    encode(">=")

;;; Conditionals
*** if
    encode("if")

*** else
    encode("else")

*** endif
    encode("endif")
  
;;; Looping constructs
*** do
    encode("do")

*** loop
    encode("loop")

*** i
    encode("i")

*** j
    encode("j")

*** k
    encode("k")

*** repeat
    encode("repeat")

*** until
    encode("until")

*** enter-rendering-loop
    encode("enter-rendering-loop")
;;; I/O
*** check-esc
    encode("check-esc")

;;; Memory management
*** allot
    encode("allot")

;;; Strings
*** str-pre
    encode("str-pre")
    encode("
*** str-post
")
    encode("str-post")

*** str-cat
    encode("str-cat")

*** str-free
    encode("str-free")

;;; STDIO
*** print
    encode("print")

*** println
    encode("println")

*** read
    encode("read")

;;; Graphics for oldskool
*** putpixel
    encode("putpixel")

*** putpixel2
    encode("putpixel2")

*** flip
    encode("flip")

*** cls
    encode("cls")

*** setpal
    encode("setpal")

===