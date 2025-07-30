// -----------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Second level of the pyramid.
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/christmas-pyramid
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <shared.scad>

// --- post for fence   ------------------------------------------------------

module fence_post(r) {
  difference() {
    zrot(30) regular_prism(6,z_level2_fence, r, anchor=BOTTOM+CENTER);
    // cutout level1-post cone
    zmove(-fuzz) cyl(zc_bottom+fuzz, r=pc_bottom+gap/2,
                     anchor=BOTTOM+CENTER);
  }
}

// --- wall cutout   ---------------------------------------------------------

module wall_cutout() {
  zmove(-fuzz)
    linear_extrude(wyc_bottom+fuzz)
      ring(n=4,r=x_level1_post-wz_bottom/2-gap,ring_width=wz_bottom+2*gap);
}

// --- fence cutout   --------------------------------------------------------

module fence_cutout(r) {
  wall = x_level2_fence+gap;
  color("blue") zmove(h_bottom)
   tube(ir=r-wall/2,
        or=r+wall/2, h=z_level2_fence, anchor=BOTTOM+CENTER);
}

// --- level2 plate   --------------------------------------------------------

module level2() {
  // plate
  difference() {
    union() {
      cyl(r=x_level1_post+po_bottom,
               h=h_bottom,chamfer2=c_bottom,
                    anchor=BOTTOM+CENTER);
      // posts for the fence
      for (r = [0:90:330]) {
        zrot(r) xmove(x_level1_post) fence_post(pr_bottom);
      }
    }
    // cutout for bottom wall
    wall_cutout();
    fence_cutout(x_level1_post);
    // cutout for cone of level1 posts
    for (r = [0:90:330]) {
      zrot(r) xmove(x_level1_post)
        zmove(-fuzz) cyl(h_bottom+2*fuzz,pc_bottom+gap,
                         anchor=BOTTOM+CENTER);
    }
    // cutout cable from level1
    move([x_level1_post-pr_bottom/2,0,h_bottom-fuzz])
         cuboid([pr_bottom,pr_bottom-w2,pr_bottom], anchor=BOTTOM+CENTER);
  }
}

// --- final shape   ---------------------------------------------------------

difference() {
  level2();
//  zmove(-fuzz) cyl(r=0.6*x_level1_post,
//               h=h_bottom+2*fuzz,
//                    anchor=BOTTOM+CENTER);
}