include<parameters.scad>

ecal_height=pcb_height;
ecal_width=pcb_width;
ecal_inner_gap=pcb_inner_gap;

wscfi_thickness=17*cm;
wscfi_position=-wscfi_thickness/2;

lightguides_thickness=2.5*cm;
lightguides_position=-wscfi_thickness-lightguides_thickness/2;

lightguides_thickness=2.5*cm;
lightguides_position=-wscfi_thickness-lightguides_thickness/2;

//0.1 cm Al + 10.15 cm air + .25 cm PCB
ecal_pcb_thickness=0.25*cm;
ecal_pcb_position=lightguides_position-lightguides_thickness/2-ecal_pcb_thickness/2;

ecal_air_thickness=10.15*cm;
ecal_air_position=ecal_pcb_position-ecal_air_thickness/2-ecal_air_thickness/2;

ecal_cover_thickness=0.1*cm;
ecal_cover_position=ecal_air_position-ecal_air_thickness/2-ecal_cover_thickness/2;

module ecal_component_side(hole_radius=bpc_hole_radius(0),thickness=17*cm, height=pcb_height, width=ecal_width,inner_gap=ecal_inner_gap, holePosition=bpc_hole_position(0))
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
                rotate([90,0,0]) translate([holePosition, 0, 0]) cylinder(h=thickness*1.5, r=hole_radius,center=true);
                translate([holePosition/2,0, 0]) cube([abs(holePosition), thickness*1.5,2*hole_radius], true);
                
            }
        }
        
        
    }
}

module ecal_component(hole_radius=bpc_hole_radius(0),thickness=17*cm, height=pcb_height, width=ecal_width,inner_gap=ecal_inner_gap, holePosition=bpc_hole_position(0)){
    ecal_component_side(width=width-100, thickness=thickness, height=height, hole_radius=hole_radius, inner_gap=inner_gap, holePosition=holePosition);
    mirror([0,1,0]) ecal_component_side(holePosition=-holePosition,width=width+100,thickness=thickness, height=height, inner_gap=inner_gap, hole_radius=hole_radius
    );
}


component="wscfi";
component="cover";

if (component=="wscfi")
    translate([wscfi_position,0,0])  ecal_component(thickness=wscfi_thickness);
else if (component=="lightguides")
    translate([lightguides_position,0,0])  ecal_component(thickness=lightguides_thickness);
else if (component=="pcb")
    translate([ecal_pcb_position,0,0])  ecal_component(thickness=ecal_pcb_thickness);
else if (component=="air")
    translate([ecal_air_position,0,0])  ecal_component(thickness=ecal_air_thickness);
else if (component=="cover")
    translate([ecal_cover_position,0,0])  ecal_component(thickness=ecal_cover_thickness);