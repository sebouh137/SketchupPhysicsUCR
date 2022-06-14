include<parameters.scad>


echo("height is", scint_height);
echo("width is", scint_width);

//create a small part of a sphere that can be subtracted from a more complicated object
module dimple(depth, radius){
    epsilon=0.01;
    rotate_extrude($fn=20) intersection(){
        circle(radius,$fn=20);
        translate([radius/2-epsilon/2, -depth/2-radius/2]) square([radius*3, 2*radius+epsilon-depth]);
    }
}

 module regular_polygon(order = 4, r=1){
     angles=[ for (i = [0:order-1]) i*(360/order) ];
     coords=[ for (th=angles) [r*cos(th), r*sin(th)] ];
     polygon(coords);
 }
 
 //cell_side_length=0.88*cm; // 2 cm^2
//cell_side_length=1.24*cm;  //  4 cm^2
//cell_side_length=1.39*cm; // 5 cm^2
cell_side_length=1.52*cm; // 5 cm^2

dimple_sphere_radius=.38*cm;
dimple_depth=.16*cm;

module hex_scint(hole_radius, delta_phi=scint_cell_dphi, groove_width=0.2*cm, groove_depth=0.2*cm,thickness=scint_thickness, cell_radius_delta=scint_cell_dr, height=scint_height, width=scint_width,cell_center_min_distance_from_edge=scint_cell_center_min_distance_from_edge,inner_gap=scint_inner_gap,make_dimples=true, make_grooves=true, cell_side_length=cell_side_length, holePosition=77)
{   
    mirror([0,1,0]){
    epsilon=0.1;
    diagonal=sqrt(height*height/4+width*width);
    
    
    
    //miny=-height/2+cell_side_length*sqrt(3)/2;
    //maxy = height/2;
    
    ny=floor(height/(cell_side_length*sqrt(3)/2)+1);
    miny=-floor(ny/2)*cell_side_length*sqrt(3)/2;
    maxy=-miny;
    
    //miny=-height/2+cell_side_length*sqrt(3)/2;
    //maxy = height/2;
    
    
    minx=width-(floor(width/(3/2*cell_side_length))*3/2+1/2)*cell_side_length;///2;
    maxx = width;               
    
    
    difference(){
        intersection(){
            //base volume
            rotate([0,0,-90]) difference() {
                translate([-width/2-inner_gap, 0, 0]) cube([width, thickness*2, height],center= true);
                rotate([90,0,0]) translate([holePosition,0,0]) cylinder(h=thickness*2, r=hole_radius,center=true, $fn=32);
                translate([holePosition/2,0, 0]) cube([abs(holePosition), 100,2*    hole_radius], true);
            }
            union(){
                rotate([0,0,-90]) difference() {
                    translate([-width/2-inner_gap, -groove_depth/2, 0]) cube([width, thickness-groove_depth, height],center= true);
                    rotate([90,0,0]) translate([holePosition,0,0]) cylinder(h=thickness*2, r=hole_radius,center=true, $fn=32);
                }
                    
                    //actually, here we create the cells
                    if(make_grooves){
                    
                        rotate([-90, 0, 90]) translate([0,0, -thickness/2])linear_extrude(thickness, true) union(){
                            for(i=[0:ny ]){
                                y = miny+i*cell_side_length*sqrt(3)/2;
                                offsetx = i%2*cell_side_length*3/2;
                                for(x= [minx+offsetx:cell_side_length*3: maxx]){
                                    translate([width+inner_gap+groove_width/sqrt(3)-x,y]) regular_polygon(6, cell_side_length-groove_width/sqrt(3));
                                }
                            }
                        }
                    }
            }
        }
        //dimples
     
     
        
        rotate([0,0,90])
        if(make_dimples){ 
            
            for(i=[0:ny ]){
                y = miny+i*cell_side_length*sqrt(3)/2;
                offsetx = i%2*cell_side_length*3/2;
                for(x= [minx+offsetx:cell_side_length*3: maxx]){
                    //if(abs(x)<width+inner_gap-cell_center_min_distance_from_edge &&              abs(y)<height/2-cell_center_min_distance_from_edge){
                //echo("x,y", x,y);
                    //translate([x,-thickness/2-(dimple_sphere_radius-dimple_depth),y]) rotate([90,0,0]) dimple( dimple_depth, dimple_sphere_radius);
                         translate([width+inner_gap+groove_width/sqrt(3)-x,-thickness/2-(dimple_sphere_radius-dimple_depth),y]) rotate([90,0,0]) intersection(){
                          translate([0,0, -dimple_sphere_radius+dimple_depth/2]) cube([2*dimple_sphere_radius+epsilon,2*dimple_sphere_radius+epsilon,dimple_depth+epsilon],center=true);  //cube([5*dimple_sphere_radius,5*dimple_sphere_radius,5*dimple_sphere_radius],center=true);
                            sphere(dimple_sphere_radius, $fn=18);
                            
                    //}
                }
            }
        }
        }
    }
    }
}

// rendering options (overwritten by commandline)
hex_scint_details=true; // include details
hex_scint_all_layers=false; // render all layers or just one
hex_scint_layer=0;  // which layer to render if hex_scint_all_layers=false

//make_grooves=hex_scint_details
make_grooves =true;
make_dimples=true;

if(hex_scint_all_layers){
    //last layer is absorber only.  
    for(layer_number=[0:bpc_nlayers-2])
        translate([scint_position+bpc_layer_thickness*layer_number,0,0]) {
                hex_scint(hole_radius=bpc_hole_radius( layer_number),make_grooves=hex_scint_details, make_dimples=hex_scint_details);
                mirror([0,1,0]) hex_scint(hole_radius=bpc_hole_radius( layer_number),make_grooves=make_grooves, make_dimples=hex_make_dimples);
            }
} else {
    translate([0,0,0]) hex_scint(hole_radius=bpc_hole_radius(hex_scint_layer),make_grooves=make_grooves, make_dimples=make_dimples);
}





