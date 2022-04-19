include<parameters.scad>


echo("height is", spider_scint_height);
echo("width is", spider_scint_width);

//create a small part of a sphere that can be subtracted from a more complicated object
module dimple(depth, radius){
    epsilon=0.01;
    rotate_extrude($fn=20) intersection(){
        circle(radius,$fn=20);
        translate([radius/2-epsilon/2, -depth/2-radius/2]) square([radius*3, 2*radius+epsilon-depth]);
    }
}

module spider_scint(hole_radius, delta_phi=scint_cell_dphi, groove_width=0.2*cm, groove_depth=0.2*cm,thickness=spider_scint_thickness, cell_radius_delta=scint_cell_dr, height=spider_scint_height, width=spider_scint_width,cell_center_min_distance_from_edge=scint_cell_center_min_distance_from_edge,inner_gap=spider_scint_inner_gap,make_dimples=true, make_grooves=true)
{   
    epsilon=0.1;
    diagonal=sqrt(height*height/4+width*width);
    rotate([0,0,-90]) difference() {
        //board
        translate([-width/2-inner_gap, 0, 0]) cube([width, thickness, height],center= true);
        union(){
        rotate([90,0,0]) cylinder(h=thickness*2, r=hole_radius,center=true);
            
        
        
        //dimples
        // Subtract the dimples first, before the grooves.  Maybe this speeds up the rendering?  
        dimple_sphere_radius=.38*cm;
        dimple_depth=.16*cm;
        if(make_dimples) for(r = [hole_radius+cell_radius_delta/2:cell_radius_delta:diagonal]){
            
            for(phi = [90+delta_phi/2:delta_phi:270]){
                x=r*cos(phi);
                y=r*sin(phi);
                if(abs(x)<width+inner_gap-cell_center_min_distance_from_edge && abs(y)<height/2-cell_center_min_distance_from_edge){
                //echo("x,y", x,y);
                    //translate([x,-thickness/2-(dimple_sphere_radius-dimple_depth),y]) rotate([90,0,0]) dimple( dimple_depth, dimple_sphere_radius);
                    translate([x,-thickness/2-(dimple_sphere_radius-dimple_depth),y]) rotate([90,0,0]) intersection(){
                        sphere(dimple_sphere_radius, $fn=10);
                        translate([0,0, -dimple_sphere_radius+dimple_depth/2]) cube([2*dimple_sphere_radius+epsilon,2*dimple_sphere_radius+epsilon,dimple_depth+epsilon],center=true);
                    }
                }
            }
        }
        
        
        //grooves
        //here I first define the grooves as a 2d object, then extrude it, then subtract it.  
        if(make_grooves) rotate([90,0,0]) translate([0,0,thickness/2-groove_depth]) linear_extrude(height=groove_depth+epsilon){
            intersection(){
                translate([-width, 0]) square([width*2,height*2],center=true);
                union(){
                    //radial grooves
                    for (phi = [delta_phi:delta_phi:180]) {
                        rotate(phi) square([groove_width,diagonal*2.2], center=true);   
                    }
                    //arc grooves
                    for (r = [hole_radius+cell_radius_delta:cell_radius_delta:diagonal]) {
                        
                        difference () {
                            circle(r=r+groove_width/2);
                            circle(r=r-groove_width/2);
                        //remove wedges from the groove in order to merge cells near the outer edge (if necessary)
                            for(phi = [0:delta_phi:45]){
                                if (abs((r+cell_radius_delta/2)*cos(phi-delta_phi/2))>width+inner_gap-cell_center_min_distance_from_edge) {
                                    polygon([[0,0],[-2*r*cos(phi),2*r*sin(phi)], [-2*r*cos(phi), -2*r*sin(phi)]]);
                                
                                }
                                if (abs((r+cell_radius_delta/2)*cos(phi-delta_phi/2))>height/2-cell_center_min_distance_from_edge){
                                    polygon([[-2*r*cos(90-phi),2*r*sin(90-phi)],[0,0], [-2*r*cos(90-phi), -2*r*sin(90-phi)], [2*r, -2*r],[2*r, 2*r]]);
                                
                                }      
                            }
                        }
                    }
                }
            }
        }
        }
        
        
        
        
        
        
    }
}

// rendering options (overwritten by commandline)
spider_scint_details=false; // include details
spider_scint_all_layers=true; // render all layers or just one
spider_scint_layer=0;  // which layer to render if spider_scint_all_layers=false

if(spider_scint_all_layers){
    //last layer is absorber only.  
    for(layer_number=[0:bpc_nlayers-2])
        translate([spider_scint_position+bpc_layer_thickness*layer_number,0,0]) {
                spider_scint(hole_radius=bpc_hole_radius( layer_number),make_grooves=spider_scint_details, make_dimples=spider_scint_details);
                mirror([0,1,0]) spider_scint(hole_radius=bpc_hole_radius( layer_number),make_grooves=spider_scint_details, make_dimples=spider_scint_details);
            }
} else {
    translate([spider_scint_position,0,0]) spider_scint(hole_radius=bpc_hole_radius(spider_scint_layer),make_grooves=spider_scint_details, make_dimples=spider_scint_details);
}





