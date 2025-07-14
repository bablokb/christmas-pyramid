// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): 
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/christmas-pyramid
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <shared.scad>

x_btn_pcb = 49.1;
y_btn_pcb = 15.4;
z_btn_pcb = 1.6;
h_btn_pcb = 4.0;      // height of button-base

x_btn_holder = x_btn_pcb + 2*w2 + gap;
y_btn_holder = y_btn_pcb + 2*w2 + gap;

xo_btn_screw = 3.5;    // screw-hole offset from each side
d_btn_screw  = 3.0;    // screw-hole diameter

x_btn_cutout = 34.5;   // x-dim button cutout (5 buttons)
y_btn_cutout = 6.3;    // y-dim button cutout (single row)
yo_btn_cutout = 2.8;   // y-offset from lower edge

x_btn_sup = (x_btn_pcb-x_btn_cutout)/2 - 2*gap;
y_btn_sup = y_btn_holder;

// --- helper functions to expose dimensions   -------------------------------

function btn_holder_dim(x) = x + gap + 2*w2;


// --- base with cutout   ----------------------------------------------------

module btn_base(h) {
  difference () {
    cuboid([x_btn_holder,y_btn_holder,h],anchor=BOTTOM+CENTER);
    // cutout
    zmove(-fuzz)
      ymove(-y_btn_pcb/2+y_btn_cutout/2+yo_btn_cutout)
        cuboid([x_btn_cutout,y_btn_cutout,h+2*fuzz],anchor=BOTTOM+CENTER);
  }
}

// --- button-pcb support   ---------------------------------------------------

module btn_support(h) {
  z_btn_sup = h_btn_pcb;
  cuboid([x_btn_sup,y_btn_sup,z_btn_sup],anchor=BOTTOM+CENTER);
  zmove(z_btn_sup-fuzz)
    cyl(d=d_btn_screw-gap,h=z_btn_pcb,anchor=BOTTOM+CENTER);
}

// --- button-holder   --------------------------------------------------------

module btn_holder(h) {
  // base
  btn_base(h);
  // supports left and right
  xflip_copy()
    xmove(-x_btn_pcb/2+x_btn_sup/2)
      btn_support(h);
  // tube
  rect_tube(size=[x_btn_holder,y_btn_holder],wall=w2,
            h=h_btn_pcb+z_btn_pcb,anchor=BOTTOM+CENTER);
}

// --- test object   ---------------------------------------------------------

//btn_holder(wz_bottom);
