// -----------------------------------------------------------------------------
// 3D-Model (OpenSCAD): PCB-holder.
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/christmas-pyramid
// ---------------------------------------------------------------------------

include <dimensions.scad>
include <BOSL2/std.scad>

z_pcb_def = 1.6;
z_sup_def = 2.0;

// --- helper functions to expose dimensions   -------------------------------

function pcb_holder_dim(x) = x + 2*gap + 2*w4;
function pcb_holder_z(z_pcb=z_pcb_def,z_support=z_sup_def) = z_pcb+z_support+b;

// --- supports   ------------------------------------------------------------

module supports(x_size,y_size,x_sup,y_sup,z_sup,
                xl_screw,xr_screw,y_screw,sups) {
  x = x_sup + w4 + gap;
  y = y_sup + w4 + gap;
  xl_off = -x_size/2 + xl_screw;
  xr_off =  x_size/2 - xr_screw;
  y_off  =  y_size/2 - y_screw;
  if (sups[0]) {
    move([xl_off,+y_off,0]) cuboid([x,y,z_sup],anchor=BOTTOM+CENTER);
  }
  if (sups[1]) {
    move([xr_off,+y_off,0]) cuboid([x,y,z_sup],anchor=BOTTOM+CENTER);
  }
  if (sups[2]) {
    move([xr_off,-y_off,0]) cuboid([x,y,z_sup],anchor=BOTTOM+CENTER);
  }
  if (sups[3]) {
    move([xl_off,-y_off,0]) cuboid([x,y,z_sup],anchor=BOTTOM+CENTER);
  }
}

// --- screws   ----------------------------------------------------------------

module screws(d,x_size,y_size,h_size,xl_screw,xr_screw,y_screw,screws) {
  xl_off = -x_size/2 + xl_screw;
  xr_off =  x_size/2 - xr_screw;
  y_off  =  y_size/2 - y_screw;
  r      = d/2 - gap/2;
  if (screws[0]) {
    move([xl_off,+y_off,0]) cyl(r=r,h=h_size,anchor=BOTTOM+CENTER);
  }
  if (screws[1]) {
    move([xr_off,+y_off,0]) cyl(r=r,h=h_size,anchor=BOTTOM+CENTER);
  }
  if (screws[2]) {
    move([xr_off,-y_off,0]) cyl(r=r,h=h_size,anchor=BOTTOM+CENTER);
  }
  if (screws[3]) {
    move([xl_off,-y_off,0]) cyl(r=r,h=h_size,anchor=BOTTOM+CENTER);
  }
}

// --- pcb-holder   ------------------------------------------------------------

module pcb_holder(
         x_pcb, y_pcb, z_pcb=z_pcb_def,
         x_support = 6.0, y_support = 6.0, z_support = z_sup_def, supports = [1,1,1,1],
         xl_screw = 3, xr_screw = 3,
         y_screw = 3, d_screw = 2.5, screws = [1,1,1,1]) {

  // box dimensions
  x_case = pcb_holder_dim(x_pcb);
  y_case = pcb_holder_dim(y_pcb);

  difference() {
    union() {
      // base plate
      cuboid([x_case,y_case,b],anchor=BOTTOM+CENTER);
      // suport and screws
      supports(x_pcb,y_pcb,x_support,y_support,b+z_support,
               xl_screw,xr_screw,y_screw,supports);
      screws(d_screw,x_pcb,y_pcb,b+z_support+z_pcb,xl_screw,xr_screw,y_screw,screws);
      // walls around pcb
      rect_tube(size=[x_case,y_case],wall=w4,h=b+z_pcb+z_support,anchor=BOTTOM+CENTER);
    }
    x_sd = 15;
    move([-pcb_holder_dim(x_pcb)/2+x_sd/2+w4,
          -pcb_holder_dim(y_pcb)/2+w2,
          0]) cuboid([x_sd,2*w4,pcb_holder_z()+fuzz],anchor=BOTTOM+CENTER);
  }
}
