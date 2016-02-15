;;;
;;; Test for JS DOM API
;;;
#DOM

program

vars
    var root  |
    var stuff |
    var tf    |
endvars

;;; What interop?
*** cheatz
    print("window.alert('I cheated with ' + " .. ds[sp] .. ");")
    sp = sp - 1
===

fun Button_Clicked ->
    [stuff] cheatz
fend

*** DOM/get-value
  ds[sp] = ds[sp] .. ".value;";

*** string
  ds[sp] = "'" .. ds[sp] .. "'"

===

fun Stuff_Entered ->
    [tf] DOM/get-value {stuff}
fend


;;; element< callback >;

: button<
   begin
     vars1 'button A
     "button" DOM/create-element {button}
     [button] DOM/set-inner-html
     [button] "click" DOM/event
: textfield<
    begin
        vars1 'textfield A
        "input" DOM/create-element {textfield}
        [textfield] DOM/set-inner-html
        [textfield] "input" DOM/event
: >;
     DOM/as-listener
     [A] >p
     return1
  end

: store-root
  "root" DOM/get-element-by-id {root}

: =>root
   [root] DOM/append-child

===

main
  " " {stuff}
  store-root
  "Enter stuff" textfield< Stuff_Entered >; p> {tf} [tf] =>root
  "Click me" button< Button_Clicked >; p> =>root
end-program
