include<parameters.scad>
use <SpiderScint.scad>
use<cover.scad>
use<cblock.scad>
use<pcb.scad>


shift_x=-50*cm;
add_separation=15*cm;
echo("cm", cm);

translate([cblock_position,shift_x,0]) cblock(hole_radius=bpc_hole_radius(0));

translate([cover_position+add_separation,shift_x,0])  cover(hole_radius=bpc_hole_radius(0));

translate([spider_scint_position+2*add_separation,shift_x,0]) rotate([0,0,180]) spider_scint(hole_radius=bpc_hole_radius(0),make_grooves=true, make_dimples=true);

translate([pcb_position+3*add_separation,shift_x,0])  pcb(hole_radius=bpc_hole_radius(0), make_sipms=true);
