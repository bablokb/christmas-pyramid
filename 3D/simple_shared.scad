// -----------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Shared dimensions for simple version.
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/christmas-pyramid
// ---------------------------------------------------------------------------

include <dimensions.scad>
include <motor_dims.scad>

// --- dimensions of base   --------------------------------------------------

d_bottom = 120;
h_iwall = b + 6;      // height inner wall

// --- specfic motor dimensions   --------------------------------------------

z_delta    = 10;                      // additional motor height above ground
z_support  = 2*(z_motor + z_delta);   // height of motor above base
