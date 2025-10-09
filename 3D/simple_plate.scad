// -----------------------------------------------------------------------------
// 3D-Model (OpenSCAD): A minimal version of the pyramid (turntable plate).
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
include <tt_plate.scad>

s_delta = 4;

difference() {
  tt_plate(b,d_bottom/2);
  for (r = [0:60:300])
    zrot(r) move([d_top/2-s_delta,0,-fuzz])
      linear_extrude(b+2*fuzz) star(n=7, r=4, step=3);
  for (r = [30:60:330])
    zrot(r) move([d_top/2+s_delta,0,-fuzz])
      linear_extrude(b+2*fuzz) star(n=7, r=4, step=3);
}
