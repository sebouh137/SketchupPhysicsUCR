mkdir -p output_stl


feature_args="--enable fast-csg --enable fast-csg-trust-corefinement \
              --enable fast-csg-exact --enable lazy-union --enable sort-stl --export-format binstl "




for side in left right; do
    # absorbers
    for ((i=0; i<=50; i++)); do
	OpenSCAD $feature_args -o output_stl/absorbers_${i}_${side}.stl -D object=\"absorbers\" -D firstLayer=$i -D lastLayer=$i -D side=\"$side\" BPC.scad 
    done
    
        
    for ((i=0; i<=49; i++)); do
	#covers:  These are very simple shapes, so we can import all of them at once                                             
	OpenSCAD $feature_args -o output_stl/covers_${i}_${side}.stl -D object=\"cover\" -D firstLayer=$i -D lastLayer=$i -D side=\"$side\" BPC.scad
	if (("$i" < "7")); then
	    #9 cm^2
	    cell_side_length=18.6
	elif (("$i" < "14")); then
	    #25 cm^2
	    cell_side_length=31.0
	else
	    #36 cm^2
	    cell_side_length=37.2
	fi
	OpenSCAD $feature_args -o output_stl/pcb_${i}_${side}.stl -D object=\"pcb\" -D firstLayer=$i -D lastLayer=$i -D side=\"$side\" -D cell_side_length=$cell_side_length BPC.scad 
	OpenSCAD $feature_args -o output_stl/hexscint_${i}_${side}.stl -D object=\"scint\" -D firstLayer=$i -D lastLayer=$i -D side=\"$side\" -D cell_side_length=$cell_side_length BPC.scad
    done
        
done

wait







