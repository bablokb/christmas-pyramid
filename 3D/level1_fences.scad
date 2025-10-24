// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Fences for level1-segment.
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/christmas-pyramid
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <shared.scad>

h_cutout = wz_bottom + 2*fuzz;

// --- candle (cutout)   ----------------------------------------------------

module candle2d(r=5) {
  ymove(3*r) {
    skew(axy=10) teardrop2d(r=r, ang=30);
    ymove(-r) rect([3,r]);
    ymove(-3*r-1) rect([3*r,4*r],rounding=[3,3,0,0],corner_flip=true);
  }
}

// --- base fence   ---------------------------------------------------------

module fence() {
  y_scale = 50;
  y_mult  =  8;
  y_diff  = y_scale - y_mult;
  z_fence = z_level1_fence - h_bottom;
  points = [
    [0,0],
    for (i = [0 : 360]) [ i, cos(i)*y_mult+y_diff ],
    [ 360, 0 ]
  ];
  difference() {
    // move to center bottom after extruding scaled polygon
    move([-wx_bottom/2,-z_fence/2,0])
      linear_extrude(wz_bottom)
        scale([wx_bottom/360,1/y_scale*z_fence,1]) polygon(points);
    // fence posts are solid in the lower part, so remove some stuff
    co_x = wxc_bottom+gap;
    co_y = zc_level1_fence-b+fuzz;
    xflip_copy()
      move([-wx_bottom/2+co_x/2-fuzz,-z_fence/2+co_y/2-fuzz,-fuzz])
        cuboid([co_x,co_y,wz_bottom+2*fuzz], anchor=BOTTOM+CENTER);
    }
  }
 
// --- star fence   ----------------------------------------------------------
 
 module fence_stars(step=3) {
  difference() { 
    fence();
    xflip_copy()
      move([-wx_bottom/3-4,+z_level1_fence/6,-fuzz])
        linear_extrude(h_cutout) star(n=7, r=4, step=step);
      move([0,-z_level1_fence/4+2,-fuzz])
        linear_extrude(h_cutout) star(n=7, r=4, step=step);
  }
}

// --- candle fence   --------------------------------------------------------
 
 module fence_candles() {
  fac1 = 0.3; fac2 = 0.2;
  difference() { 
    fence();
    xflip_copy()
      move([-wx_bottom/3-3,-3,-fuzz])
        linear_extrude(h_cutout) scale([fac1,fac1,1]) candle2d();
    move([0,-5,-fuzz])
       linear_extrude(h_cutout) scale([fac2,fac2,1]) candle2d();
    
  }
}

// --- comet fence   ---------------------------------------------------------
 
 module fence_bethlehem() {
   factor = 0.3*wx_bottom/100;
   difference() { 
    fence();
    zmove(-fuzz) ymove(-3)
        scale([factor,factor,h_cutout]) zrot(-10)
          import("input/star_of_bethlehem.stl");  // dim: 100x30.8x1
  }
}

// --- christmas tree fence   -----------------------------------------------
 
 module fence_trees() {
   factor = 0.3*wy_bottom/100;
   difference() { 
    fence();
    zmove(-fuzz) xmove(-wx_bottom/3)
        scale([factor,factor,h_cutout])
          import("input/tree_abstract.stl");
    zmove(-fuzz) xmove(+wx_bottom/3)
        scale([factor,factor,h_cutout])
          import("input/tree_with_star.stl");
      move([0,-z_level1_fence/4+2,-fuzz])
        linear_extrude(h_cutout) star(n=7, r=4, step=3);
  }
}

// --- camel fence   ---------------------------------------------------------
 
module fence_camels() {
  factor1 = 0.2*wx_bottom/100;
  factor2 = 0.25*wy_bottom/100;
  difference() { 
    fence();
    xflip_copy()
      move([wx_bottom/4+5,-2,-fuzz])
        scale([factor1,factor1,h_cutout])
          import("input/camel.stl");
    move([0,-3.5,-fuzz])
       scale([factor2,factor2,h_cutout])
          import("input/camel_sitting.stl");
  }
}

// --- nativity fence   ------------------------------------------------------
 
 module fence_nativity() {
   factor_x = 0.14*wx_bottom/100;
   factor_y = 0.14*wx_bottom/100;
   difference() { 
    fence();
    move([-18,-2.5,-fuzz])
        scale([1.4*factor_x,1.4*factor_y,h_cutout])
          xflip() import("input/donkey.stl");
    move([-5,-2.5,-fuzz])
        scale([factor_x,factor_y,h_cutout])
          import("input/mary.stl");
    move([5,-2.5,-fuzz])
        scale([factor_x,factor_y,h_cutout])
          import("input/joseph.stl");
    move([18,-2.5,-fuzz])
        scale([1.4*factor_x,1.4*factor_y,h_cutout])
          import("input/cow.stl");
  }
}

// --- final objects   -------------------------------------------------------

distribute(l=1.1*wx_bottom) {
  distribute(l=wy_bottom, dir=BACK) {
    fence_stars();
    fence_bethlehem();
    fence_candles();
  }
  distribute(l=wy_bottom, dir=BACK) {
    fence_trees();
    fence_camels();
    fence_nativity();
  }
}
