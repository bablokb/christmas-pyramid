// -----------------------------------------------------------------------------
// 3D-Model (OpenSCAD): shared dimensions specific to the model
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/christmas-pyramid
// ---------------------------------------------------------------------------

include <dimensions.scad>

// ---------------------------------------------------------------------------
// motor support dimensions
z_motor = 19;

do_support = 7;                    // motor support
di_support = 2.5;                  // screw: 2.6
ox_support = 17.5;                 // offset of support: 35/2
oy_support = -8;
z_support  = z_motor + 10;

// ---------------------------------------------------------------------------
// motor shaft dimensions

d1_shaft = 9 + gap;
d2_shaft = 5 + gap;
d3_shaft = 3 + gap;
x_shaft = d2_shaft;
y_shaft = d3_shaft;
z1_shaft = 1.5;
z2_shaft = 4;
z3_shaft = 6;

// ---------------------------------------------------------------------------
// pcb for motor-driver

x_pcb = 65.3;
y_pcb = 42.3;

xl_pcb = 22.41;    // x_screw left side
xr_pcb = 22.57;    // x_screw right side
ys_pcb = 3;        // y_screw

// ---------------------------------------------------------------------------
// dimensions of pyramid base

x_bottom = 100;                               // radius
y_bottom = sqrt(3/4*x_bottom*x_bottom);
h_bottom =   b;
c_bottom = h_bottom;                          // chamfering
z_bottom = z_support + z2_shaft + z3_shaft;

pr_bottom = 5;                                // radius of posts
pc_bottom = 1.6;                              // radius of cone above post
po_bottom = 2*c_bottom+pr_bottom;             // offset of posts

wx_bottom = x_bottom-po_bottom -              // full width -
            2*(pr_bottom-2*pc_bottom) -       // 2x inner width of post -
	    2*gap;                            // 2x gap
wy_bottom = z_bottom-b/2;
wh_bottom = 1.6;                              // wall height (printed flat)