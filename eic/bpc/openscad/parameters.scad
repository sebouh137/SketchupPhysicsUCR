cm = 10;

//The dimensions of all other components depend on those of the square absorbers
square_absorber_height=9.8*cm;
square_absorber_width=9.6*cm;
square_absorber_thickness=2*cm;

square_absorber_horizontal_gap=0.4*cm;
square_absorber_vertical_gap=0.1897*cm;
square_absorber_longitudinal_gap=0.34*cm;

// holes in the square absorbers, cblocks, and master plates for placing connector pins.  
conn_hole_spacing=5*cm;
conn_hole_depth=1*cm;
conn_hole_radius=0.25*cm;

// BPC total dimensions
bpc_length=150*cm;
bpc_first_hole_radius=15*cm;
bpc_last_hole_radius=19*cm;
bpc_layer_thickness=square_absorber_thickness+square_absorber_longitudinal_gap;
bpc_nlayers=floor(bpc_length/bpc_layer_thickness);
function bpc_hole_radius(i)=bpc_first_hole_radius+(bpc_last_hole_radius-bpc_first_hole_radius)*i/bpc_nlayers;
//this value has not been finalized
bpc_outer_gap=2*cm;






//scintillator
spider_scint_thickness=0.3*cm;
spider_scint_height=square_absorber_height*6+5*square_absorber_vertical_gap;
spider_scint_width=square_absorber_width*3+3*square_absorber_horizontal_gap-bpc_outer_gap;
spider_scint_inner_gap=square_absorber_horizontal_gap/2;



//cells in scintillator (also defines placement of sensors on pcb)
scint_cell_center_min_distance_from_edge=.35*cm;
scint_cell_dphi=9; //degrees
scint_cell_dr=2.5*cm;

//pcb
pcb_thickness=.236*cm;
pcb_height=square_absorber_height*6+5*square_absorber_vertical_gap;
pcb_width=square_absorber_width*3+3*square_absorber_horizontal_gap-bpc_outer_gap;
pcb_inner_gap=square_absorber_horizontal_gap/2;

// ESR film
ESR_film_thickness=0.015*cm;

//air gap
air_gap_thickness=0.02*cm;

//cover
cover_thickness=0.2*cm;
cover_height=square_absorber_height*6+5*square_absorber_vertical_gap;
cover_width=square_absorber_width*3+3*square_absorber_horizontal_gap-bpc_outer_gap;
cover_inner_gap=square_absorber_horizontal_gap/2;

//cblock
cblock_thickness=bpc_layer_thickness-pcb_thickness-spider_scint_thickness-2*air_gap_thickness-2*ESR_film_thickness-cover_thickness;
cblock_height=square_absorber_height*6+5*square_absorber_vertical_gap;
cblock_width=square_absorber_width*3+3*square_absorber_horizontal_gap-bpc_outer_gap;
cblock_inner_gap=square_absorber_horizontal_gap/2;


//longitudinal positions of the first layer
cblock_position=cblock_thickness/2;
cover_position=cblock_thickness+air_gap_thickness+cover_thickness/2;
spider_scint_position=cblock_thickness+air_gap_thickness+cover_thickness+ESR_film_thickness+spider_scint_thickness/2;
pcb_position=cblock_thickness+air_gap_thickness+cover_thickness+ESR_film_thickness+spider_scint_thickness+ESR_film_thickness+pcb_thickness/2;
echo(cblock_thickness);
