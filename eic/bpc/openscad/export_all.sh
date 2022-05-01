
mkdir output_stl

for a in SpiderScint cover cblock pcb explode_view; do
    /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o output_stl/${a}.stl ${a}.scad
done
