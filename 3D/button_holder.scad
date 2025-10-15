// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Button-Holder for panel-mount buttons.
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/christmas-pyramid
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <dimensions.scad>

//      n=   1     2  3     4     5     TODO: add size for 1 and 3 buttons
x_btn_pcb = [0, 28.6, 0, 42.1, 49.1];
y_btn_pcb = 15.4;
z_btn_pcb = 1.6;
h_btn_pcb = 4.0;      // height of button-base


xo_btn_screw = 3.5;    // screw-hole offset from each side
d_btn_screw  = 3.0;    // screw-hole diameter

x_btn_cutout = [0, 13.3, 0, 27.4, 34.5];   // x-dim button cutout
y_btn_cutout = 6.3;    // y-dim button cutout (single row)
yo_btn_cutout = 2.8;   // y-offset from lower edge

y_btn_holder  = y_btn_pcb + 2*w2 + gap;
y_btn_sup     = y_btn_holder;
z_btn_chamfer = 2;
h_btn_holder  = h_btn_pcb+z_btn_pcb+z_btn_chamfer;

// --- helper functions to expose dimensions   -------------------------------

function btn_holder_dim(x) = x + gap + 2*w2;


// --- base with cutout   ----------------------------------------------------

module btn_base(h, n, x_dim) {
  difference () {
    cuboid([x_dim,y_btn_holder,h],anchor=BOTTOM+CENTER);
    // cutout
    zmove(-fuzz)
      ymove(+y_btn_pcb/2-y_btn_cutout/2-yo_btn_cutout)
        cuboid([x_btn_cutout[n-1],y_btn_cutout,h+2*fuzz],anchor=BOTTOM+CENTER);
  }
}

// --- button-pcb support   ---------------------------------------------------

module btn_support(n, x_dim) {
  z_btn_sup = h_btn_pcb;
  cuboid([x_dim,y_btn_sup,z_btn_sup],anchor=BOTTOM+CENTER);
  zmove(z_btn_sup-fuzz)
    cyl(d=d_btn_screw-gap,h=z_btn_pcb+z_btn_chamfer,anchor=BOTTOM+CENTER);
}

// --- button-holder   --------------------------------------------------------

module btn_holder(h_base, n, h_add=0) {
  // dimensions
  x_btn_holder = x_btn_pcb[n-1] + 2*w2 + gap;
  x_dim_sup    = (x_btn_pcb[n-1]-x_btn_cutout[n-1])/2 - 2*gap;
  // base
  btn_base(h_base, n, x_btn_holder);
  // supports left and right
  xflip_copy()
    xmove(-x_btn_pcb[n-1]/2+x_dim_sup/2)
      btn_support(n, x_dim_sup);
  // tube
  rect_tube(size=[x_btn_holder,y_btn_holder],wall=w2,
            h=h_btn_holder+h_add,anchor=BOTTOM+CENTER);
  // chamfer
  move([0,+y_btn_holder/2-w2+fuzz,h_btn_pcb+z_btn_pcb+z_btn_chamfer/2])
    xrot(90) prismoid(size1=[x_btn_holder,z_btn_chamfer],
                       size2=[x_btn_holder,0], h=z_btn_chamfer/2);
}

// --- test object   ---------------------------------------------------------

//btn_holder(1.6,5);
//ymove(-20) btn_holder(1.6,2);
//btn_holder(w2,2,5);
