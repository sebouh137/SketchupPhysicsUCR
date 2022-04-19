include<parameters.scad>
echo("Cblock thickness", cblock_thickness);
module cblock(hole_radius,thickness=cblock_thickness, height=cblock_height, width=cblock_width,inner_gap=cblock_inner_gap,fn=24)
{   
    epsilon=0.1*cm;
    rotate([0,0,90]) difference() {
        //board
        difference() {
            translate([-width/2-inner_gap, 0, 0]) cube([width, thickness, height],center= true);
            rotate([90,0,0]) cylinder(h=2*thickness, r=hole_radius,center=true);
            
        }
        // holes on top and bottom
        for (x = [conn_hole_spacing/2:-conn_hole_spacing:-width]) {
            translate([x,0,height/2-conn_hole_depth/2+epsilon/2]) cylinder(conn_hole_depth+epsilon, conn_hole_radius, conn_hole_radius, true, $fn=fn);
            translate([x,0,-(height/2-conn_hole_depth/2+epsilon/2)]) cylinder(conn_hole_depth-epsilon, conn_hole_radius, conn_hole_radius, true, $fn=fn);
            
        }
        
    }
}
//cblock(hole_radius=15);
//for (i = [0:3])
    //echo("hole radius",bpc_hole_radius(i))
//    translate([2.34*i,0, 0]) cblock(hole_radius=bpc_hole_radius(i));
    
// rendering options (overwritten by commandline)
cblock_all_layers=true; // render all layers or just one
cblock_layer=0;  // which layer to render if spider_scint_all_layers=false

if(cblock_all_layers){
    //last layer is absorber only.  
    for(layer_number=[0:bpc_nlayers-1])
        translate([cblock_position+bpc_layer_thickness*layer_number,0,0]) {
                cblock(hole_radius=bpc_hole_radius( layer_number),fn=12);
                mirror([0,1,0]) cblock(hole_radius=bpc_hole_radius( layer_number), fn=12);
            }
} else {
    translate([cblock_position,0,0]) cblock(hole_radius=bpc_hole_radius(cblock_layer));
}