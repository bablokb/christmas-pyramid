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

d_center = 2.6;                     // diameter center hole (for SURS-2p plug)

r_plate  = x_level1_post-po_bottom/2;  // center plate
h_plate  = 2*h_bottom;

x_conn =  7.1;
y_conn = 11.5;
z_conn = h_plate + 2*fuzz;

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
    // cutout for plate
    zmove(2*h_bottom/3+fuzz)
      cyl(r=r_plate,h=h_bottom/3,anchor=BOTTOM+CENTER);
    // cutout für cable to center
    zmove(h_bottom/3+fuzz)
      cuboid([x_level1_post-po_bottom/2+gap,w4,h_bottom/3], anchor=BOTTOM+LEFT);
    // cutout for hole in the center
    zmove(-fuzz)
      cyl(d=d_center,h=h_bottom+2*fuzz,anchor=BOTTOM+CENTER);
  }
}

// --- plate   ---------------------------------------------------------------

module plate() {
  difference() {
    cyl(r=r_plate-gap/2,h=h_plate, chamfer2=c_bottom, anchor=BOTTOM+CENTER);
    // cutout for SURS-connector
    zmove(-fuzz) xmove(r_plate-x_conn/2+fuzz)
      cuboid([x_conn,y_conn,z_conn], anchor=BOTTOM+CENTER);
    // cutout for cables or whatever needs space
    xmove(-d_center) zmove(-fuzz)
      cuboid([r_plate,y_conn,h_plate/2], anchor=BOTTOM+LEFT);
  }
}

// --- final shape   ---------------------------------------------------------

//difference() {
//  level2();
////  zmove(-fuzz) cyl(r=0.6*x_level1_post,
////               h=h_bottom+2*fuzz,
////                    anchor=BOTTOM+CENTER);
//}
if ($preview) {
  color("blue") zmove(h_bottom/3) plate();
} else {
   zmove(h_plate) zflip() plate();
}