include<parameters.scad>
module cover(hole_radius,thickness=cover_thickness, height=cover_height, width=cover_width,inner_gap=cover_inner_gap)
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
        }
        
        
    }
}

cover_all_layers=true; // render all layers or just one
cover_layer=0;  // which layer to render if spider_scint_all_layers=false

if(cover_all_layers){
    //last layer is absorber only.  
    for(layer_number=[0:bpc_nlayers-2])
        translate([cover_position+bpc_layer_thickness*layer_number,0,0]) {
                cover(hole_radius=bpc_hole_radius( layer_number));
                mirror([0,1,0]) cover(hole_radius=bpc_hole_radius( layer_number));
            }
} else {
    translate([cover_position,0,0])  cover(hole_radius=bpc_hole_radius(cblock_layer));
}