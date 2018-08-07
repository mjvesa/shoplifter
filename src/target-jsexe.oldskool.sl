;;; For 320x200x8bit effects
: include
"var pixels = C.createImageData(640,400);" _println
"var putpixel2 = function(color, i) {" _println
"  pixels.data[i*4]=palette[color][0];" _println
"  pixels.data[i*4+1]=palette[color][1];" _println
"  pixels.data[i*4+2]=palette[color][2];" _println
"  pixels.data[i*4+3]=255;" _println
"}" _println

;;; Graphics for oldskool
: putpixel2
  "putpixel2(" _print _print "," _print _print ");" _println
: flip
  "C.putImageData(pixels,0,0);" _println
: cls
  "virt.fill(0)" _println
: setpal
  "palette[" _print _print  " ] =[" _print _print "," _print _print"," _print _print "];" _println
: enter-rendering-loop
  "var Main_Loop = function()  {" _println
  "  Render_Frame();" _println
  "  window.requestAnimationFrame(Main_Loop);" _println
  "}" _println
  "Main_Loop();" _println
===
include
