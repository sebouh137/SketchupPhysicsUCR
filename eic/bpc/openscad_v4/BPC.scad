include<parameters.scad>
use <HexScint.scad>
use<cover.scad>
use<cblock.scad>
use<pcb.scad>

//options to be set in the command line
object="scint";
side="left";
firstLayer=0;
lastLayer=0;


cell_side_length=1.52*cm; // 5 cm^2
dimple_sphere_radius=.38*cm;
dimple_depth=.16*cm;

for(layer=[firstLayer:lastLayer]){
    echo(str("creating ",object," layer",layer,", ",side, " side"));
    if(object=="absorbers"){
        translate([cblock_position+bpc_layer_thickness*layer,0,0]) {
                if(side=="left")
                    mirror([0,1,0]) cblock(hole_radius=bpc_hole_radius( layer),fn=12,
                    holePosition=-bpc_hole_position(layer),
                    width=cblock_width+100);
                else 
                    cblock(hole_radius=bpc_hole_radius( layer), fn=12,
                    holePosition=bpc_hole_position(layer),
                    width=cblock_width-100);
            }
    }
    if(object == "cover"){
        translate([cover_position+bpc_layer_thickness*layer,0,0]) {
                if (side=="left")
                    mirror([0,1,0])cover(hole_radius=bpc_hole_radius( layer),
                    holePosition=-bpc_hole_position(layer),
                    width=cover_width+100);
                else 
                    cover(hole_radius=bpc_hole_radius( layer),
                    holePosition=bpc_hole_position(layer),
                    width=cover_width-100);
            }
    }
    
    if (object == "scint"){
        hex_make_grooves=true;
        hex_make_dimples=true;
        translate([scint_position+bpc_layer_thickness*layer,0,0]){
            if (side=="left")
                mirror([0,1,0]) hex_scint(hole_radius=bpc_hole_radius( layer),make_grooves=hex_make_grooves, make_dimples=hex_make_dimples, cell_side_length=cell_side_length,
                    holePosition=-bpc_hole_position(layer),
                    width=scint_width+100);
            else
                 hex_scint(hole_radius=bpc_hole_radius( layer),make_grooves=hex_make_grooves, make_dimples=hex_make_dimples,
                    holePosition=bpc_hole_position(layer),
                    width=scint_width-100);
        }
    }
    
    if(object=="pcb"){
        translate([pcb_position+bpc_layer_thickness*layer,0,0]) {
                if (side=="left")
                    mirror([0,1,0]) pcb(hole_radius=bpc_hole_radius( layer), make_sipms=false,
                    holePosition=-bpc_hole_position(layer),
                    width=pcb_width+100);
                else 
                    pcb(hole_radius=bpc_hole_radius( layer), make_sipms=false,
                    holePosition=bpc_hole_position(layer),
                    width=pcb_width-100);
            }
    }
}
