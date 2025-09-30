// -----------------------------------------------------------------------------
// 3D-Model (OpenSCAD): A minimal version of the pyramid (wall).
//
// This model is optimized for two perimeters. Print with transparent PLA.
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/christmas-pyramid
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <simple_shared.scad>
include <motor_dims.scad>
include <pcb_holder.scad>

// Wall height:
//   the first term is the complete height from floor
//   substract b because the wall starts at height b
//   subtract a few millimeters to stay clear of turntable.

h_wall = (z_support + 1 + z1_shaft + z2_shaft + z3_shaft) - b - 3;

// sections of the wall

h_base = 1.2*(h_iwall-b);  // base-ring

h_ring     = 4;         // top-most ring
h_cone_sup = 7;         // support cone for pixel-ring
w_cone_sup = 4;         // width of support

h_cone = h_wall-h_base-h_ring-h_cone_sup;   // main cone (bottom)
d_cone = 72+gap;                            // diameter at top

x_cutout1 = 22 + gap;   // cutout for USB-C of MCU
z_cutout1 = h_base;

x_cutout2 = 10;         // cutout for pixel-ring wires

// --- wall   ----------------------------------------------------------------

module wall() {
  // base (inner-wall)
  color("blue") tube(h=h_base,od=d_bottom,id=d_bottom-2*w2, anchor=BOTTOM+CENTER);
  // main cone
  color("red") zmove(h_base-fuzz)
    tube(h=h_cone, od1=d_bottom,id1=d_bottom-2*w2,
                       od2=d_cone,id2=d_cone-2*w2,
                       anchor=BOTTOM+CENTER);
  // support cone
  color("green") zmove(h_base+h_cone-2*fuzz)
    tube(h=h_cone_sup, od1=d_cone,id1=d_cone-2*w2,
                   od2=d_cone,id2=d_cone-8,
                   anchor=BOTTOM+CENTER);
  // top ring
  color("aqua") zmove(h_base+h_cone+h_cone_sup-3*fuzz)
    tube(h=h_ring,
         od1=d_cone,id1=d_cone-2*w2,
         od2=d_cone+2*h_ring,id2=d_cone+2*h_ring-2*w2,
         anchor=BOTTOM+CENTER);
}

// --- final shape   ---------------------------------------------------------

difference() {
  wall();
  zmove(-fuzz) ymove(d_bottom/2-w2)
    cuboid([x_cutout1,3*w2,z_cutout1], anchor=BOTTOM+CENTER);
  zmove(h_wall-h_ring-h_cone_sup) ymove(d_cone/2-w_cone_sup)
    cuboid([x_cutout2,w_cone_sup,2*h_cone_sup], anchor=BOTTOM+CENTER);
}
