mkdir -p output_csg/


feature_args="--enable fast-csg --enable fast-csg-trust-corefinement \
              --enable fast-csg-exact --enable lazy-union --enable sort-stl"
#echo "scintillators"
#OpenSCAD $feature_args -o output_csg/all_scints_low_detail.csg -D hex_scint_all_layers=true -D make_grooves=false -D make_dimples=false -D hex_scint_details=false HexScint.scad
echo "scintillators"
OpenSCAD $feature_args -o output_csg/all_scint_low_detail.csg -D scint_all_layers=true scint_low_detail.scad
echo "absorbers"
OpenSCAD $feature_args -o output_csg/all_absorbers_low_detail.csg -D cblock_all_layers=true -D cblock_dowel_holes=false cblock.scad 
echo "covers"
OpenSCAD $feature_args -o output_csg/all_covers.csg -D cover_all_layers=true cover.scad 
echo "pcb"
OpenSCAD $feature_args -o output_csg/all_pcbs.csg -D pcb_all_layers=true pcb.scad 


# to convert to STEP, open the csg files in FreeCAD.  Select all objects in the files using the Combo View panel's "Model" tab (which has an outliner of all objects in all open files).  Click on the top object of the list, scroll down to the bottom, hold down shift and then click on the bottom-most object.  Do not use "Command A" nor "Control A" nor the menu-bar command to select the objects.  There's a bug when selecting things with the Command A/Control A/menu bar way of selecting objects.  Then, from the menu bar, do File->Export... and then use the dialog that appears in order to export the 





