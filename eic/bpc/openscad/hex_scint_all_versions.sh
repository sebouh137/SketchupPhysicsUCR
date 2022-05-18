mkdir -p output_stl/hex_versions


feature_args="--enable fast-csg --enable fast-csg-trust-corefinement \
              --enable fast-csg-exact --enable lazy-union --enable sort-stl"
for cell_size in 2cm2 3cm2 4cm2 5cm2 6cm2; do
    param_args=""

    if [[ "$cell_size" == "2cm2" ]]; then
	param_args="${param_args} -D cell_side_length=8.8"
    elif [[ "$cell_size" == "3cm2" ]]; then
        param_args="${param_args} -D cell_side_length=10.7"
    elif [[ "$cell_size" == "4cm2" ]]; then
	param_args="${param_args} -D cell_side_length=12.4"
    elif [[ "$cell_size" == "5cm2" ]]; then
	param_args="${param_args} -D cell_side_length=13.9"
    elif [[ "$cell_size" == "6cm2" ]]; then
	param_args="${param_args} -D cell_side_length=15.2"
    else
	echo unrecognized cell size: $cell_size , exiting
	exit
    fi
	
    for dimple_size in large small ; do
	if [[ "$dimple_size" == "small" ]]; then
	    param_args="${param_args} -D dimple_sphere_radius=3.8 -D dimple_depth=1.6"
	elif [[ "$dimple_size" == "large" ]]; then
	    param_args="${param_args} -D dimple_sphere_radius=12.7 -D dimple_depth=1.7"
	else
            echo unrecognized dimple size: $dimple_size , exiting
	    exit
	fi
	cmd="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o output_stl/HexScint_${dimple_size}_${cell_size}.stl \
						       $feature_args \
						       $param_args \
						       HexScint.scad"
	echo $cmd
	$cmd
    done
done
