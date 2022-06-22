include<parameters.scad>
module scint_low_detail(hole_radius,thickness=scint_thickness, height=scint_height, width=scint_width,inner_gap=scint_inner_gap, holePosition=77)
{   
    epsilon=0.1*cm;
    sipm_width=0.6*cm;
    sipm_height=0.6*cm;
    sipm_depth=0.1*cm;
    rotate([0,0,90]) difference() {
        union(){
            
            diagonal=sqrt(height*height/4+width*width);
            //board
            difference() {
                translate([-width/2-inner_gap, 0, 0]) cube([width, thickness, height],center= true);
                //union(){
                    //if(holePosition < 0)
                 translate([holePosition/2,0, 0]) cube([abs(holePosition), 100,2*hole_radius], true);
               rotate([90,0,0]) translate([holePosition, 0, 0])  cylinder(h=10, r=hole_radius,center=true, $fn=32);
                    
                //}
                
            }
        }
        
        
    }
}

scint_all_layers=true; // render all layers or just one
scint_layer=0;  // which layer to render if spider_scint_all_layers=false

if(scint_all_layers){
    //last layer is absorber only.  
    for(layer_number=[0:bpc_nlayers-2])
        translate([scint_position+bpc_layer_thickness*layer_number,0,0]) {
                scint_low_detail(hole_radius=bpc_hole_radius( layer_number),
                holePosition=bpc_hole_position(layer_number), width=scint_width-100);
                mirror([0,1,0]) scint_low_detail(
                        hole_radius=bpc_hole_radius( layer_number),
                        holePosition=-bpc_hole_position(layer_number),
                        width=scint_width+100
                        );
            }
} else {
    translate([scint_position,0,0])  scint_low_detail(hole_radius=bpc_hole_radius(scint_layer));
}