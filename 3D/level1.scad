// -----------------------------------------------------------------------------
// 3D-Model (OpenSCAD): First level of the pyramid.
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/christmas-pyramid
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <shared.scad>
include <pcb_holder.scad>

r_ttable = x_level1 - 2*po_bottom;      // radius turn-table
g_ttable = 2;                           // gap turn-table

r2_fence_post = 1+gap;      // fence post top radius of cutout-cone

// --- posts for next level of pyramid   -------------------------------------

module post(h,r,twist=120) {
  difference() {
    union() {
      // post
      if ($preview) {
        cyl(h,r, anchor=BOTTOM+CENTER);
      } else {
        // supershape is very slow in rendering
        // linear_extrude(h,twist=twist) supershape(.5,m1=8,n1=1,r=r);
        linear_extrude(h,twist=twist) star(n=8, r=r, step=2);
      }
      // cone above post
      zmove(h-fuzz) cyl(zc_bottom,pc_bottom, anchor=BOTTOM+CENTER);
    }
  }
}

// --- post for fence   ------------------------------------------------------

module fence_post(r) {
  difference() {
    regular_prism(6,z_level1_fence, r, anchor=BOTTOM+CENTER);
    // cutout base-post cone
    zmove(-fuzz) cyl(zc_bottom+fuzz, r=pc_bottom+gap,
                     anchor=BOTTOM+CENTER);
    // cutout cylinder within fence-post
    zmove(zc_bottom-fuzz) cyl(z_level1_fence-zc_bottom+2*fuzz,
                              r1=pc_bottom+gap, r2=r2_fence_post,
                              anchor=BOTTOM+CENTER);
    // cutouts for fences
    zmove(zc_level1_fence)
      zrot(30) ymove(pr_bottom-wxc_bottom)
        cuboid([wz_bottom+gap,10,z_level1_fence+fuzz], anchor=BOTTOM+FRONT);
    zmove(zc_level1_fence)
      zrot(-30) ymove(-pr_bottom+wxc_bottom)
        cuboid([wz_bottom+gap,10,z_level1_fence+fuzz], anchor=BOTTOM+BACK);
  }
}

// --- wall cutout   ---------------------------------------------------------

module wall_cutout() {
  zmove(-fuzz)
    linear_extrude(wyc_bottom+fuzz)
      ring(n=6,r=x_bottom-po_bottom-wz_bottom/2-gap,ring_width=wz_bottom+2*gap);
}

// --- turntable plate   -----------------------------------------------------

module tt_plate(h_add,r_add) {
  cyl(h_add+h_bottom, r_add+r_ttable, anchor=BOTTOM+CENTER);
}

// --- level1 plate   --------------------------------------------------------

module level1() {
  // plate
  difference() {
    regular_prism(6,h_bottom,x_bottom,chamfer2=c_bottom,
            anchor=BOTTOM+CENTER);
    // cutout for bottom wall
    wall_cutout();
    // cutout for cone of base posts
    for (r = [0:60:300]) {
      zrot(r) xmove(x_bottom-po_bottom)
        zmove(-fuzz) cyl(h_bottom+2*fuzz,pc_bottom+gap,
                         anchor=BOTTOM+CENTER);
    }
    // cutout turntable
    zmove(-fuzz) tt_plate(2*fuzz,g_ttable);
    // cutout stars for ventilation
    for (r = [0:60:300]) {
      zrot(r) zmove(-fuzz)
        xmove(x_level1 - po_bottom + (x_bottom-x_level1)/2)
         linear_extrude(h_bottom+2*fuzz) star(n=7, r=4, step=3);
    }
  }
  // posts for the next level
  for (r = [0:60:300]) {
    zrot(r) xmove(x_level1-po_bottom) post(z_level1,pr_bottom);
  }
  // posts for the fence
  for (r = [0:60:300]) {
    zrot(r) xmove(x_bottom-po_bottom) fence_post(pr_bottom);
  }
}

// --- final shape   ---------------------------------------------------------

intersection() {
  level1();
  //xmove(30) cuboid([100,200,10],anchor=BOTTOM+LEFT);
  xmove(x_bottom-po_bottom) cyl(r=10, h=60,anchor=BOTTOM+CENTER);
}