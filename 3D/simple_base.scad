// -----------------------------------------------------------------------------
// 3D-Model (OpenSCAD): A minimal version of the pyramid.
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/christmas-pyramid
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <shared.scad>
include <pcb_holder.scad>

d_bottom = 120;

x_pcb_uln2003a = 21;
y_pcb_uln2003a = 40.8;

x_pcb_mcu = 18.1;
y_pcb_mcu = 23.2;

x_pcb_dfplayer = 21;
y_pcb_dfplayer = 21;

h_iwall = b + 6;      // height inner wall
co_pcb  = 3;          // cutout for PCB (diff to border)

// --- module post: cylinder with hole   -------------------------------------

module motor_post() {
  tube(h=z_support,od=do_support,id=di_support, anchor=BOTTOM+CENTER);
}

// --- module motor-support   ------------------------------------------------

module motor_support() {
  move([+ox_support,oy_support,0]) motor_post();
  move([-ox_support,oy_support,0]) motor_post();
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

// --- pcb-holders   ---------------------------------------------------------

module p_holder(x_pcb,y_pcb) {
 pcb_holder(x_pcb=x_pcb, y_pcb=y_pcb, screws=[0,0,0,0], supports=[0,0,0,0]);
}

// --- base plate   ----------------------------------------------------------

module base() {
  difference() {
    union() {
      // base-plate
      cylinder(h=b,d=d_bottom, anchor=BOTTOM+CENTER);
      // support for motor
      motor_support();
      // pcb-holders
      xmove(-d_bottom/2+20) p_holder(x_pcb_uln2003a,y_pcb_uln2003a);
      ymove(-d_bottom/2+pcb_holder_dim(y_pcb_mcu)/2 + 1.25*w4) 
          p_holder(x_pcb_mcu,y_pcb_mcu);
      move([+d_bottom/2-20,
            -pcb_holder_dim(y_pcb_uln2003a)/2+pcb_holder_dim(y_pcb_dfplayer)/2,
            0])
          p_holder(x_pcb_dfplayer,y_pcb_dfplayer);
      // lid for second DFPlayer cutout
        move([+d_bottom/2-20,
                pcb_holder_dim(y_pcb_dfplayer)/2+w4,
                b-fuzz])
            cuboid([x_pcb_dfplayer,pcb_holder_dim(y_pcb_dfplayer),2.6],
                   anchor=BOTTOM+CENTER);  
    }
    // cutout MCU (chip is below PCB)
    zmove(-fuzz)
      ymove(-d_bottom/2+pcb_holder_dim(y_pcb_mcu)/2 -co_pcb/2 + 1.25*w4) 
        cuboid([x_pcb_mcu-2*co_pcb,y_pcb_mcu-co_pcb,b+2*fuzz],
               anchor=BOTTOM+CENTER);  
    // cutout DFPlayer (flipped, SD-card is on bottom), first part
    move([+d_bottom/2-20,
            -pcb_holder_dim(y_pcb_uln2003a)/2+pcb_holder_dim(y_pcb_dfplayer),
            0.6])
        cuboid([x_pcb_dfplayer-2*co_pcb,2*y_pcb_dfplayer,b-0.6+fuzz],
               anchor=BOTTOM+CENTER);  
    // cutout DFPlayer, second part
    move([+d_bottom/2-20,
            pcb_holder_dim(y_pcb_dfplayer)/2,
            -fuzz])
        cuboid([x_pcb_dfplayer-2*co_pcb,pcb_holder_dim(y_pcb_dfplayer),b+1.6+fuzz],
               anchor=BOTTOM+CENTER);
  }
  // cable-holders
  //cable_holders();
}

// --- wall   ----------------------------------------------------------------

module inner_wall() {
  difference() {
    tube(h=h_iwall,od=d_bottom-2*w2,id=d_bottom-4*w2, anchor=BOTTOM+CENTER);
    ymove(-d_bottom/2)
      cuboid([pcb_holder_dim(x_pcb_mcu),10,50], anchor=BOTTOM+CENTER);
  }  
}

// --- final shape   ---------------------------------------------------------

//base();
//color("blue") inner_wall();

// test print mcu-holder
intersection() {
  base();
  color("blue") ymove(-d_bottom/2+pcb_holder_dim(y_pcb_mcu)/2 -co_pcb/2 + 1.25*w4)
    cuboid([pcb_holder_dim(x_pcb_mcu)+5,pcb_holder_dim(y_pcb_mcu)+5,20],
               anchor=BOTTOM+CENTER);
}

// test print dfplayer-holder
intersection() {
  base();
  color("blue")
    move([+d_bottom/2-20,
         -pcb_holder_dim(y_pcb_uln2003a)/2+pcb_holder_dim(y_pcb_dfplayer),
         0])
  
    cuboid([pcb_holder_dim(x_pcb_dfplayer)+5,2*pcb_holder_dim(y_pcb_dfplayer)+5,20],
               anchor=BOTTOM+CENTER);
}