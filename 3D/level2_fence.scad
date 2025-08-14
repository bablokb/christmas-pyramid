// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): fence for level2
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/christmas-pyramid
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <shared.scad>

steps = $preview ? 30:360;

// --- level2 fence   --------------------------------------------------------
//
// max height is h, mean height is h-h_delta/2, min height is h-h_delta

module level2_fence(r,wall,h,h_delta,steps) {
  y = 0.5*(r+wall/2)*PI/steps;    // circumference-of-quarter-circle/steps
  difference() {
    yflip_copy()
      xflip_copy()
        for (a = [0:90/steps:90]) {
          zrot(a)
            xmove(r) cuboid([wall,y,h-0.5*h_delta + 0.5*h_delta*cos(4*a)],
                anchor=BOTTOM+CENTER);
        }
    // cutouts for level1 posts
    for (a = [0:90:270])
      zrot(a)
        move([x_level1_post,0,-fuzz])
         cuboid([pr_bottom,2*(pc_bottom+gap),pr_bottom], anchor=BOTTOM+CENTER);
  }
}

level2_fence(r=x_level1_post, wall=x_level2_fence,
             h=z_level2_fence, h_delta=6,
             steps=steps);
