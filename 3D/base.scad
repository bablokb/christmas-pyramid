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
      zmove(h-fuzz) cyl(b,pc_bottom);
    }
    // cutouts for walls
    zrot(30) ymove(pr_bottom-2*pc_bottom)
        cuboid([wh_bottom+gap,10,h+b+fuzz], anchor=BOTTOM+FRONT);
    zrot(-30) ymove(-pr_bottom+2*pc_bottom)
        cuboid([wh_bottom+gap,10,h+b+fuzz], anchor=BOTTOM+BACK);
  }
}

// --- wall cutout   ---------------------------------------------------------

module wall_cutout() {
  zmove(b-wc_bottom)
    linear_extrude(wc_bottom+fuzz)
      ring(n=6,r=x_bottom-po_bottom-wh_bottom/2-gap,ring_width=wh_bottom+2*gap);
}

// --- base plate   ----------------------------------------------------------

module base() {
  // base-plate
  difference() {
    regular_prism(6,h_bottom,x_bottom,chamfer2=c_bottom,
            anchor=BOTTOM+CENTER);
    wall_cutout();
  }
  // support for motor
  motor_support();
  // pcb-holder, moved and rotated to the back side
  ymove(y_bottom - pcb_holder_dim(y_pcb)/2 - po_bottom)
    zrot(180)
      pcb_holder(x_pcb=x_pcb,   y_pcb=y_pcb,
                 xl_screw = xl_pcb, xr_screw = xr_pcb, y_screw = ys_pcb);
  // posts for the next level
  for (r = [0:60:300]) {
    zrot(r) xmove(x_bottom-po_bottom) post(z_bottom,pr_bottom);
  }
}

// --- final shape   ---------------------------------------------------------

base();
//post(z_bottom,pr_bottom);
//pcb_holder(x_pcb=x_pcb,   y_pcb=y_pcb,
//             xl_screw = xl_pcb, xr_screw = xr_pcb, y_screw = ys_pcb);
