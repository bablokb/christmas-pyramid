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
  points = [
    [0,0],
    for (i = [0 : 360]) [ i, cos(i)*y_mult+y_diff ],
    [ 360, 0 ]
  ];
  // move to center bottom after extruding scaled polygon
  move([-wx_bottom/2,-z_level1_fence/2,0])
    linear_extrude(wz_bottom)
      scale([wx_bottom/360,1/y_scale*z_level1_fence,1]) polygon(points);
  }
 
// --- star fence   ----------------------------------------------------------
 
 module fence_stars(step=3) {
  difference() { 
    fence();
    xflip_copy()
      move([-wx_bottom/3-5,+z_level1_fence/6,-fuzz])
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
      move([-wx_bottom/3-5,-2,-fuzz])
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
    zmove(-fuzz) ymove(-2)
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
  factor = 0.2*wx_bottom/100;
  difference() { 
    fence();
    xflip_copy()
      move([wx_bottom/4+5,-2,-fuzz])
        scale([factor,factor,h_cutout])
          import("input/camel.stl");
    xflip_copy()
      move([wx_bottom/8,-5,-fuzz])
        scale([0.5*factor,0.5*factor,h_cutout])
          import("input/camel.stl");
  }
}

// --- nativity fence   ------------------------------------------------------
 
 module fence_nativity() {
   factor_x = 0.7*wx_bottom/100;
   factor_y = 0.6*wx_bottom/100;
   difference() { 
    fence();
    zmove(-fuzz) ymove(-3)
        scale([factor_x,factor_y,h_cutout])
          import("input/nativity_fence.stl");  // dim: 100x30.8x1
  }
}

// --- final objects   -------------------------------------------------------
//fence_stars();
//fence_bethlehem();
//fence_candles();
//fence_trees();
//fence_camels();
fence_nativity();
