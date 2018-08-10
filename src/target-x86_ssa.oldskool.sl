: putpixel2
  "push 0x8000" _println
  "pop es" _println
  "mov bx, " _print _get-NOS _println
  "mov ax, " _print _get-TOS _println
  "mov [es:bx], al" _println
  _pop-reg _pop-reg

: setpal
  "mov ax, " _print _get-TOS _println
  "push dx" _println
  "mov dx,3c8h" _println
  "out dx, al" _println
  "pop dx" _println
  "mov ax, " _print _get-4th _println
  "shr al, 2" _println
  "push dx" _println
  "mov dx, 3c9h" _println
  "out dx, al" _println
  "pop dx" _println
  "mov ax, " _print _get-3rd _println
  "shr al, 2" _println
  "push dx" _println
  "mov dx,3c9h" _println
  "out dx, al" _println
  "pop dx" _println
  "mov ax, " _print _get-TOS _println
  "shr al, 2" _println
  "push dx" _println
  "mov dx, 3c9h" _println
  "out dx, al" _println
  "pop dx" _println
  _pop-reg _pop-reg
  _pop-reg _pop reg

: flip
  "push 0xa000" _println
  "pop es" _println
  "push di" _println
  "push ds" _println
  "push 0x8000" _println
  "pop ds" _println
  "xor bx, bx" _println
  "xor di, di" _println
  "fliploop:" _println
  "mov al, [bx]" _println
  "mov ah, al" _println
  "mov [es:di], ax" _println
  "inc bx" _println
  "inc di" _println
  "inc di" _println
  "jnz fliploop" _println
  "pop ds" _println
  "pop di" _println
  

===