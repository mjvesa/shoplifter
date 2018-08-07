;;; For 320x200x8bit effects
: include
"var putpixel  = function(color, y, x) {" _println
"    virt[(x + y * 640) & 252143] = palette[color];" _println
"}" _println
"var putpixel2 = function(color, i) {" _println
"    virt[i & 262143] = palette[color];" _println
"}" _println
"var C = document.getElementById(\"canvas\").getContext(\"2d\");" _println
"var flip = function() {" _println
"  var i = 0;" _println
"  var j = 0;" _println
"  var pixels = C.createImageData(640,400);" _println
"  for (var y = 0 ; y < 400 ; y++) {" _println
"        for (var x = 0 ; x < 640 ; x++) {" _println
"           pixels.data[j] = virt[i] & 255;" _println
"           pixels.data[j + 1] = (virt[i] >> 8) & 255;" _println
"           pixels.data[j + 2] = (virt[i] >> 16) & 255;" _println
"           pixels.data[j + 3] = 255;" _println
"           i++;" _println
"          j+=4;" _println
"      }" _println
"    }" _println
"   C.putImageData(pixels,0,0);" _println
"}" _println


;;; Graphics for oldskool
: putpixel
  "putpixel(" _print _print "," _print _print "," _print _print ");" _println
: putpixel2
  "putpixel2(" _print _print "," _print _print ");" _println
: flip
  "flip();" _println
: cls
  "virt.fill(0)" _println
: setpal
  "palette[" _print _print  " ] = " _print _print " * 65536 + " _print _print" * 256 + " _print _print ";" _println

: enter-rendering-loop
  "var Main_Loop = function()  {" _println
  " Render_Frame();" _println
  "  window.requestAnimationFrame(Main_Loop);" _println
  "}" _println
  "Main_Loop();" _println
===
include
