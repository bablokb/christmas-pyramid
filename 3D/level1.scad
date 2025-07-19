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

r2_fence_post = 2.1;    // fence post top radius of cutout-cone
r_cable_cutout = 1.7;   // cutout for cable from base through level1 to level2

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
    zmove(-fuzz) cyl(zc_bottom+fuzz, r=pc_bottom+gap/2,
                     anchor=BOTTOM+CENTER);
    // cutout cylinder within fence-post
    zmove(zc_bottom-fuzz) cyl(z_level1_fence-zc_bottom+2*fuzz,
                              r1=pc_bottom+gap/2, r2=r2_fence_post,
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

// --- lamp-shade (for fence-posts)   ----------------------------------------
//
// Note: print in vase-mode, nature/transparent PLA recommended

module lamp_shade() {
  r2 = r2_fence_post + 0.25;  // should be -something, but prints smaller
  difference() {
    union() {
      cyl(h=10,r1=pr_bottom,
          r2=r2,anchor=BOTTOM+CENTER);
      cyl(h=15,r=r2,anchor=BOTTOM+CENTER);
    }
    zmove(-1) cyl(h=10,r1=pr_bottom-gap,r2=r2,anchor=BOTTOM+CENTER);
  }
}

// --- level1 plate   --------------------------------------------------------

module level1() {
  // plate
  difference() {
    union() {
      regular_prism(6,h_bottom,x_bottom,chamfer2=c_bottom,
                    anchor=BOTTOM+CENTER);
      // posts for the next level
      for (r = [0:60:300]) {
        zrot(r) xmove(x_level1-po_bottom) post(z_level1,pr_bottom);
      }
      // posts for the fence
      for (r = [0:60:300]) {
        zrot(r) xmove(x_bottom-po_bottom) fence_post(pr_bottom);
      }
    }
 
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
    // cutout single post next level for cable
    zmove(-fuzz) zrot(60) xmove(x_level1-po_bottom)
       cyl(h=z_level1+zc_bottom+2*fuzz,r=r_cable_cutout,anchor=BOTTOM+CENTER);
  }
}

// --- final shape   ---------------------------------------------------------

intersection() {
  level1();
  //xmove(30) cuboid([100,200,10],anchor=BOTTOM+LEFT);
  //xmove(x_bottom-po_bottom) cyl(r=10, h=60,anchor=BOTTOM+CENTER);
}

//lamp_shade();
