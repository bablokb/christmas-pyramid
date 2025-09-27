// -----------------------------------------------------------------------------
// 3D-Model (OpenSCAD): shared dimensions specific to the model
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/christmas-pyramid
// ---------------------------------------------------------------------------

include <dimensions.scad>
include <motor_dims.scad>

// ---------------------------------------------------------------------------
// individual motor support dimensions

z_delta    = 10;                      // additional height above ground
z_support  = z_motor + z_delta;       // height of motor above base

// ---------------------------------------------------------------------------
// motor shaft dimensions

d1_shaft = 9 + gap;     // shaft at bottom (motor-side, circle-shaped)
z1_shaft = 1.5;
d2_shaft = 5 + gap;     // shaft above bottom (circle-shaped)
z2_shaft = 4;
d3_shaft = 3 + gap;     // shaft at top (flat)
z3_shaft = 6;

// ---------------------------------------------------------------------------
// pcb for motor-driver

x_pcb = 65.3;
y_pcb = 42.3;

xl_pcb = 25.09;    // x_screw left side
xr_pcb = 19.73;    // x_screw right side
ys_pcb = 3;        // y_screw

// ---------------------------------------------------------------------------
// dimensions of pyramid base

x_bottom = 85;                                // radius
y_bottom = sqrt(3/4*x_bottom*x_bottom);
h_bottom =   b;
c_bottom = h_bottom;                          // chamfering
z_bottom = z_support + 1 + z1_shaft + z2_shaft + z3_shaft;

// ---------------------------------------------------------------------------
// posts
pr_bottom = 5;                                // radius of posts
pc_bottom = 3;                                // radius of cone above post
zc_bottom = 2*b;                              // height of cone above post
po_bottom = 2*c_bottom+pr_bottom;             // offset of posts

// ---------------------------------------------------------------------------
// walls (printed flat, i.e. y is height (z) dimension

wyc_bottom = 0.6;                             // cutout depth below/above walls
wxc_bottom = pc_bottom;                       // cutout depth within posts
wx_bottom = x_bottom-po_bottom -              // width of post-hexagon -
            2*(pr_bottom-wxc_bottom)          // 2x (radius-width_of_cutouts)
	    - 2*gap;                          // - 2x gap
wy_bottom = z_bottom-b + 2*wyc_bottom - gap;  // wall height (orthogonal)
wz_bottom = 1.6;                              // wall height (printed flat)

// ---------------------------------------------------------------------------
// Scale factor of levels

level_scale = 0.67;

// ---------------------------------------------------------------------------
// dimensions of level1

x_level1 = level_scale*x_bottom;
z_level1 = 60;
zc_level1 = z_level1/3;                          // cutout for walls in post
z_level1_fence  = 20;
zc_level1_fence  = 14;                           // cutout for fences in post

r_ttable = x_level1 - 2*po_bottom;               // radius turn-table
g_ttable = 2;                                    // gap turn-table
//x_level1_post = sqrt(2)*(r_ttable+g_ttable);   // hull fully outside turn-table
x_level1_post = x_level1-po_bottom;              // hull intersects with turn-table

// ---------------------------------------------------------------------------
// walls level1 (printed flat, i.e. y is height (z) dimension

wx_level1 = sqrt(2*x_level1_post^2) -            // side of square (c=sqrt(a^2+b^2)) -
              2*(pr_bottom-wxc_bottom);          // 2x (radius-width_of_cutouts)
wy_level1 = zc_level1 + wyc_bottom - gap/2;
wz_level1 = wz_bottom;

// ---------------------------------------------------------------------------
// dimensions of level2

z_level2_fence  = 15;
x_level2_fence  = w2;
