// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Walls for base-segment.
//
// Print walls with silhouette (all except pcb and speaker) with a
// color-change after three layers. The first three layers should use
// transparent PLA, the other layers in the color you like.
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/christmas-pyramid
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <shared.scad>
include <pcb_holder.scad>
include <button_holder.scad>

h_cutout = 1.2;     // six layers a 0.2
rs_speaker = 3;     // stars for speaker
d_speaker  = 29;    // speaker itself
h_speaker  =  4.4;  // height of speaker

x_sd =  18;         // size of SD-cutout
y_sd =   7;         // printed, will be vertical later

x_usb  = 16;        // size of USB-C
y_usb  =  8;
yo_usb = 13;        // offset from bottom

x_holder  = 24;     // pcb-holder
yo_holder = pcb_holder_z() - b - wyc_bottom;
z_holder  =  8;

// --- base wall   -----------------------------------------------------------

module wall() {
  cuboid([wx_bottom,wy_bottom,wz_bottom], anchor=BOTTOM+CENTER);
}

// --- wall for PCB   --------------------------------------------------------

module wall_pcb() {
  off_corners = 6;
  h_cutouts = wz_bottom+2*fuzz;
  difference() {
    union() {
      wall();
      move([0,-wy_bottom/2+y_usb/2+yo_usb,wz_bottom-fuzz])
        cuboid([2*x_usb,y_usb-2*fuzz,0.75*w4], anchor=BOTTOM+CENTER);
    }
    // cutouts
    // SD-card
    move([+wx_bottom/2-x_sd/2+fuzz,-wy_bottom/2+y_sd/2-fuzz,-fuzz])
      cuboid([x_sd,y_sd,h_cutouts], anchor=BOTTOM+CENTER);
    // USB-C
    move([0,-wy_bottom/2+y_usb/2+yo_usb,-fuzz])
      cuboid([x_usb,y_usb,wz_bottom+h_cutouts],
             rounding=3, edges="Z", anchor=BOTTOM+CENTER);
    // cutout buttons
    zmove(-fuzz)
      ymove(wy_bottom/2-y_btn_holder/2-wyc_bottom)
        hull() btn_holder(wz_bottom);

    // for some air-flow
    move([-wx_bottom/2+off_corners,-wy_bottom/2+off_corners,-fuzz])
      linear_extrude(h_cutouts) star(n=7, r=4, step=3);
    move([-wx_bottom/2+off_corners,+wy_bottom/2-off_corners,-fuzz])
      linear_extrude(h_cutouts) star(n=7, r=4, step=3);
    move([+wx_bottom/2-off_corners,+wy_bottom/2-off_corners,-fuzz])
      linear_extrude(h_cutouts) star(n=7, r=4, step=3);
  }
  // pcb-holder
  move([0,-wy_bottom/2+wyc_bottom+w2+yo_holder,-fuzz])
    cuboid([x_holder,w2,z_holder], anchor=BOTTOM+CENTER);
  // button-holder
  ymove(wy_bottom/2-y_btn_holder/2-wyc_bottom) btn_holder(wz_bottom);
}

// --- wall for speaker   ----------------------------------------------------

module wall_speaker() {
  difference() {
    wall();
    // cutouts stars
    move([0,0,-fuzz])
      linear_extrude(wz_bottom+2*fuzz) star(n=7, r=rs_speaker, step=3);
    for (i = [2:2:4]) {
      for (r = [0:120/i:360]) {
        move([0,0,-fuzz])
          zrot(r+(i-1)*15) ymove(i*rs_speaker)
            linear_extrude(wz_bottom+2*fuzz) star(n=7, r=rs_speaker, step=3);
      }
    }
  }
  zmove(wz_bottom-fuzz) tube(h=h_speaker, id=d_speaker, wall=w2,
                             anchor=BOTTOM+CENTER);
}

// --- wall with nativity scene   --------------------------------------------

module wall_nativity() {
  factor = 0.6*wx_bottom/100;
  difference() {
    wall();
    // cutouts
    zmove(b-h_cutout+fuzz)
        scale([factor,factor,h_cutout])
          import("input/nativity.stl");  // dim: 100x69.2x1
  }
}

// --- wall with star of Bethlehem   -----------------------------------------

module wall_bethlehem() {
  factor = 0.8*wx_bottom/100;
  difference() {
    wall();
    // cutouts
    zmove(b-h_cutout+fuzz)
        scale([factor,factor,h_cutout]) zrot(-10)
          import("input/star_of_bethlehem.stl");  // dim: 100x30.8x1
  }
}

// --- wall with angels   ---------------------------------------------------

module wall_angels() {
  factor = 0.7*wy_bottom/100;
  difference() {
    wall();
    // cutouts
    xmove(-wx_bottom/4) zmove(b-h_cutout+fuzz)
        scale([factor,factor,h_cutout])
          import("input/angel_trompet.stl");  // dim: 70.5x100x1
    xmove(+wx_bottom/4) zmove(b-h_cutout+fuzz)
        scale([factor,factor,h_cutout])
          import("input/angel_praying.stl");  // dim: 66.1x100x1
  }
}

// --- wall with stars   -----------------------------------------------------

module wall_stars(step=3) {
  difference() {
    wall();
    // cutouts: randomly placed stars
    move([-wx_bottom/3+5,-wy_bottom/6+5,b-h_cutout+fuzz])
      linear_extrude(h_cutout) star(n=7, r=4, step=step);
    move([-wx_bottom/3,+wy_bottom/3,b-h_cutout+fuzz])
      linear_extrude(h_cutout) star(n=8, r=5, step=step);
    move([-wx_bottom/6,-wy_bottom/3,b-h_cutout+fuzz])
      linear_extrude(h_cutout) star(n=8, r=5, step=step);
    move([0,0,b-h_cutout+fuzz])
      linear_extrude(h_cutout) star(n=8, r=3, step=step);
    move([+wx_bottom/6,+wy_bottom/6,b-h_cutout+fuzz])
      linear_extrude(h_cutout) star(n=7, r=4, step=step);
    move([+wx_bottom/3,0,b-h_cutout+fuzz])
      linear_extrude(h_cutout) star(n=8, r=5, step=step);
    move([+wx_bottom/3+3,+wy_bottom/3-2,b-h_cutout+fuzz])
      linear_extrude(h_cutout) star(n=8, r=3, step=step);
    move([+wx_bottom/6+2,-wy_bottom/6-3,b-h_cutout+fuzz])
      linear_extrude(h_cutout) star(n=7, r=4, step=step);

  }
}

// --- main   ----------------------------------------------------------------

//wall_stars();
//wall_bethlehem();
//wall_nativity();
//wall_angels();
//wall_speaker();
wall_pcb();
