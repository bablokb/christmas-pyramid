// -----------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Base level of the pyramid.
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/christmas-pyramid
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <shared.scad>
include <pcb_holder.scad>

ch_off = 0.6 * x_bottom;   // cable-holder offset

// --- module post: cylinder with hole   -------------------------------------

module motor_post() {
  tube(h=z_support,od=do_support,id=di_support, anchor=BOTTOM+CENTER);
}

// --- module motor-support   ------------------------------------------------

module motor_support() {
  move([+ox_support,oy_support,0]) motor_post();
  move([-ox_support,oy_support,0]) motor_post();
}

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
    // cutouts for walls
    zrot(30) ymove(pr_bottom-wxc_bottom)
        cuboid([wz_bottom+gap,10,h+b+fuzz], anchor=BOTTOM+FRONT);
    zrot(-30) ymove(-pr_bottom+wxc_bottom)
        cuboid([wz_bottom+gap,10,h+b+fuzz], anchor=BOTTOM+BACK);
    // cutouts for LED-cable
    zrot(-90) zmove(0.67*h+b) xrot(-8)
        cuboid([wz_bottom+gap,10,h/3+b+fuzz], anchor=BOTTOM+BACK);
  }
}

// --- a single cable-holders   ----------------------------------------------

module cable_holder() {
  x_holder = 3*b; y_holder = 2*b; z_holder = 4*b;
  zmove(x_holder/2+w4) yrot(90)
    rect_tube(isize=[x_holder,y_holder],wall=w4,h=z_holder,anchor=CENTER);
}

// --- all cable-holders   ---------------------------------------------------

module cable_holders() {
  xflip_copy() {
    zrot(0) xmove(ch_off) cable_holder();
    yflip_copy()
      zrot(-60)
        zrot(-30,cp=[x_bottom-po_bottom,0,0])
          xmove(ch_off) cable_holder();
  }
}

// --- wall cutout   ---------------------------------------------------------

module wall_cutout() {
  zmove(b-wyc_bottom)
    linear_extrude(wyc_bottom+fuzz)
      ring(n=6,r=x_bottom-po_bottom-wz_bottom/2-gap,ring_width=wz_bottom+2*gap);
}

// --- base plate   ----------------------------------------------------------

module base() {
  // base-plate
  r_ring = 2*ox_support;
  w_ring = 5;
  difference() {
    regular_prism(6,h_bottom,x_bottom,chamfer2=c_bottom,
            anchor=BOTTOM+CENTER);
    wall_cutout();
    zmove(-fuzz) ymove(oy_support)
      linear_extrude(h_bottom+2*fuzz)
       ring(r=r_ring, ring_width=w_ring, full=false, angle=[180,360]);
  }
  // support for motor
  motor_support();
  // pcb-holder, moved and rotated to the back side
  ymove(y_bottom - pcb_holder_dim(y_pcb)/2 - po_bottom + gap)
    zrot(180)
      pcb_holder_special(x_pcb=x_pcb,   y_pcb=y_pcb,
                 xl_screw = xl_pcb, xr_screw = xr_pcb, y_screw = ys_pcb);
  // posts for the next level
  for (r = [0:60:300]) {
    zrot(r) xmove(x_bottom-po_bottom) post(z_bottom,pr_bottom);
  }
  // cable-holders
  cable_holders();
}

// --- final shape   ---------------------------------------------------------

base();
//post(z_bottom,pr_bottom);
//pcb_holder_special(x_pcb=x_pcb,   y_pcb=y_pcb,
//                   xl_screw = xl_pcb, xr_screw = xr_pcb, y_screw = ys_pcb);
//cable_holder();
