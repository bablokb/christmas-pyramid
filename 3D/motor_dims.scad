// -----------------------------------------------------------------------------
// 3D-Model (OpenSCAD): dimensions of moter.
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/christmas-pyramid
// ---------------------------------------------------------------------------

include <dimensions.scad>

// ---------------------------------------------------------------------------
// motor support dimensions

z_motor = 19;                      // size of motor without shaft

do_support = 7;                    // motor support outer diameter
di_support = 2.5;                  // motor support inner diameter (screw: 2.6)
ox_support = 17.5;                 // offsets of support: 35/2
oy_support = -8;

// ---------------------------------------------------------------------------
// motor shaft dimensions

d1_shaft = 9 + gap;     // shaft at bottom (motor-side, circle-shaped)
z1_shaft = 1.5;
d2_shaft = 5 + gap;     // shaft above bottom (circle-shaped)
z2_shaft = 4;
d3_shaft = 3 + gap;     // shaft at top (flat)
z3_shaft = 6;
