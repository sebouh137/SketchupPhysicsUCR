mkdir -p output_stl/hex_versions


feature_args="--enable fast-csg --enable fast-csg-trust-corefinement \
              --enable fast-csg-exact --enable lazy-union --enable sort-stl"




for side in left right; do
    #first set of absorbers: W
    OpenSCAD $feature_args -o output_stl/absorbers_1-21_${side}.stl -D object=\"absorbers\" -D firstLayer=0 -D lastLayer=20 -D side=\"$side\" BPC.scad 
    #second set of absorbers: Fe
    OpenSCAD $feature_args -o output_stl/absorbers_22-51_${side}.stl -D object=\"absorbers\" -D firstLayer=21 -D lastLayer=50 -D side=\"$side\" BPC.scad 
    
    #covers                                                                          
    OpenSCAD $feature_args -o output_stl/covers_${side}.stl -D object=\"cover\" -D firstLayer=0 -D lastLayer=49 -D side=\"$side\" BPC.scad 

    #pcb and scintillators, layers 1-7
    OpenSCAD $feature_args -o output_stl/pcb_1-7_${side}.stl -D object=\"pcb\" -D firstLayer=0 -D lastLayer=6 -D side=\"$side\" -D cell_side_length=18.6 BPC.scad 
    OpenSCAD $feature_args -o output_stl/hexscint_1-7_${side}.stl -D object=\"scint\" -D firstLayer=0 -D lastLayer=6 -D side=\"$side\" -D cell_side_length=18.6 BPC.scad 

    #layers 8-14
    OpenSCAD $feature_args -o output_stl/pcb_8-14_${side}.stl -D object=\"pcb\" -D firstLayer=7 -D lastLayer=13 -D side=\"$side\" -D cell_side_length=31.0 BPC.scad 
    OpenSCAD $feature_args -o output_stl/hexscint_8-14_${side}.stl -D object=\"scint\" -D firstLayer=7 -D lastLayer=13 -D side=\"$side\" -D cell_side_length=31.0 BPC.scad 

    #layers 15-50
    OpenSCAD $feature_args -o output_stl/pcb_15-50_${side}.stl -D object=\"pcb\" -D firstLayer=14 -D lastLayer=49 -D side=\"$side\" -D cell_side_length=37.2 BPC.scad 
    OpenSCAD $feature_args -o output_stl/hexscint_15-50_${side}.stl -D object=\"scint\" -D firstLayer=14 -D lastLayer=49 -D side=\"$side\" -D cell_side_length=37.2 BPC.scad 
    
done

wait







