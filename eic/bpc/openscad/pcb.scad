include<parameters.scad>
module pcb(hole_radius,thickness=pcb_thickness, height=pcb_height, width=pcb_width,inner_gap=pcb_inner_gap, delta_phi=scint_cell_dphi, make_sipms=true)
{   
    epsilon=0.1*cm;
    sipm_width=0.6*cm;
    sipm_height=0.6*cm;
    sipm_depth=0.1*cm;
    rotate([0,0,90]) difference() {
        union(){
            
            diagonal=sqrt(height*height/4+width*width);
            //board
            color("green")  difference() {
                translate([-width/2-inner_gap, 0, 0]) cube([width, thickness, height],center= true);
                rotate([90,0,0]) cylinder(h=10, r=hole_radius,center=true);
                
            }
            if(make_sipms) for(r = [hole_radius+scint_cell_dr/2:scint_cell_dr:diagonal]) {
                for(phi = [90+delta_phi/2:delta_phi:270]) {
                    if(abs(r*cos(phi))<width+inner_gap-scint_cell_center_min_distance_from_edge && abs(r*sin(phi))<height/2-scint_cell_center_min_distance_from_edge) {
                    translate([r*cos(phi),+thickness/2+(sipm_depth-epsilon)/2,r*sin(phi)]) color("grey") cube([sipm_width, sipm_depth+epsilon, sipm_height],center=true);
                    }
                }
            }
        }
        
        
    }
}

pcb_all_layers=true; // render all layers or just one
pcb_layer=0;  // which layer to render if spider_scint_all_layers=false

if(pcb_all_layers){
    //last layer is absorber only.  
    for(layer_number=[0:bpc_nlayers-2])
        translate([pcb_position+bpc_layer_thickness*layer_number,0,0]) {
                pcb(hole_radius=bpc_hole_radius( layer_number), make_sipms=false);
                mirror([0,1,0]) pcb(hole_radius=bpc_hole_radius( layer_number), make_sipms=false);
            }
} else {
    translate([pcb_position,0,0])  pcb(hole_radius=bpc_hole_radius(cblock_layer), make_sipms=true);
}
//cblock(hole_radius=15);
//for (i = [0:3])
    //echo("hole radius",bpc_hole_radius(i))
    //translate([2.34*i,0, 0]) pcb(hole_radius=bpc_hole_radius(i));