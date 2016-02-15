*** program-header-html
print([[
<html>
  <head>
    <title>Shoplifter DOMinates</title>
  </head>
  <body>
    <div id="root"></div>
    <script>
]])

: program
    program-header-init
    program-header-html
    program-header-js

*** DOM/get-element-by-id
    ds[sp] = "document.getElementById(" .. ds[sp] .. ")"

*** DOM/append-child
    print(ds[sp] .. ".appendChild(" .. ds[sp - 1] .. ");")
    sp = sp - 2
;;; "div" DOM/create-element "root" DOM/get-element-by-id DOM/append-child

*** DOM/create-element
    ds[sp] = "document.createElement(" .. ds[sp] .. ")"

;;; "root" DOM/get-element-by-id "click" DOM/event Some_Function DOM/as-listener
*** DOM/event
    ds[sp - 1] = ds[sp - 1] .. ".addEventListener(" .. ds[sp] .. ","
    sp = sp - 1
    ds[sp] = ds[sp] .. "
*** DOM/as-listener
"
    print(ds[sp] .. ");")
    sp = sp - 1

*** DOM/set-inner-html
    print(ds[sp] .. ".innerHTML = " .. ds[sp - 1] .. ";")
    sp = sp  - 2

*** DOM/set-style-attribute

===