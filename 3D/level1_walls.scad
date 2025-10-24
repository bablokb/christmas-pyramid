// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): walls for level1 (three variations)
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/christmas-pyramid
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <shared.scad>

// --- level1 wall0   -------------------------------------------------------

module level1_wall0() {
  difference() {
    ymove(wy_level1/2-wxc_bottom)
      cuboid([wx_level1,2*wxc_bottom,wz_level1], anchor=BOTTOM+CENTER);
    xflip_copy()
      zmove(-fuzz) ymove(wy_level1/2-2.2*wxc_bottom) zrot(90)
        fillet(h=wz_level1+2*fuzz,r=1.5*wxc_bottom, anchor=BOTTOM+CENTER);
  }
  xflip_copy() {
    color("blue") linear_extrude(wz_level1)
      move([-wx_level1/2,wy_level1/2]) zrot(-90)
        mask2d_roundover(r=wy_level1-1.5*wxc_bottom,inset=1.5*wxc_bottom, anchor=CENTER);
  }
}

// --- level1 wall1   -------------------------------------------------------

module level1_wall1() {
  difference() {
    cuboid([wx_level1,wy_level1,wz_level1], anchor=BOTTOM+CENTER);
    zmove(-fuzz) ymove(-wy_level1/2)
      scale([3.7,2,1])
      cylinder(h=wz_level1+2*fuzz,d=0.8*wy_level1, anchor=BOTTOM+CENTER);
  }
}

// --- level1 wall2   -------------------------------------------------------

module level1_wall2() {
  d1 = 0.8*wy_level1;
  d2 = 1.0*wy_level1;
  difference() {
    cuboid([wx_level1,wy_level1,wz_level1], anchor=BOTTOM+CENTER);
    color("blue") zmove(-fuzz) xflip_copy() union() {
      xmove(-wx_level1/2+d1/2+wxc_bottom) ymove(-wy_level1/2)
        cylinder(h=wz_level1+2*fuzz,d=d1, anchor=BOTTOM+CENTER);
      xmove(-wx_level1/3+d2/2+1) ymove(-wy_level1/3+2)
        cylinder(h=wz_level1+2*fuzz,d=d2, anchor=BOTTOM+CENTER);
      ymove(-wy_level1/5+3)
        cylinder(h=wz_level1+2*fuzz,d=d1, anchor=BOTTOM+CENTER);
      ymove(-wy_level1/2)
        cylinder(h=wz_level1+2*fuzz,d=d1, anchor=BOTTOM+CENTER);
    }
  }
}

// --- final objects   --------------------------------------------------------

ycopies(wy_level1+2,4) level1_wall2();
