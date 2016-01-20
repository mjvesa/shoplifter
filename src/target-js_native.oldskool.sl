;;; For 320x200x8bit effects
*** include

print([[
var putpixel  = function(x, y, color) {
    virt[(x + y * 320) & BMOD] = palette[color];
}

var putpixel2 = function(i, color) {
    virt[i & BMOD] = palette[color];
}

var flip = function() {

    var i = 0;
    var j = 0;
    var ctx = document.getElementById("canvas").getContext("2d");
    var pixels = ctx.getImageData(0,0,160,100);

    for (var y = 0 ; y < 100 ; y++) {
        for (var x = 0 ; x < 160 ; x++) {
            pixels.data[j] = virt[i] & 255;
            pixels.data[j + 1] = (virt[i] >> 8) & 255;
            pixels.data[j + 2] = (virt[i] >> 16) & 255;
            pixels.data[j + 3] = 255;
            i++;
            j+=4;
        }
    }

    ctx.putImageData(pixels,0,0);
}
]])
===
include
