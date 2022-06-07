#Run this in the ruby console.  And then go to bed with the laptop running.

#  load "/Users/spaul/Documents/Google Sketchup/DetectorsSketchupUCR/eic/bpc/import_all_stl.rb"

require 'sketchup.rb'

dir="/Users/spaul/Documents/Google Sketchup/DetectorsSketchupUCR/eic/bpc/"

object_names = ["absorbers_1-21", "absorbers_22-51", "covers",\
                "hexscint_1-7", "hexscint_8-14", "hexscint_15-50",\
                "pcb_1-7", "pcb_8-14", "pcb_15-50"]

#object_names=["covers", "pcb_1-7"]

model=Sketchup.active_model



objects_on_sides= {}
objects_on_sides["left"] = []
objects_on_sides["right"] = []

model.start_operation("Import stuff", true) 

for name in object_names do
  for side in ["left","right"] do
    filename = dir+"openscad/output_stl/" + name+"_" + side + ".stl"
    puts "begin import "+filename
    
    model.import(filename, false)

    puts "finished import " + filename + "\n now processing"
    
    imported_object = Sketchup.active_model.entities[-1]
    imported_object.hidden = true
    objects_on_sides[side] << imported_object
    
    if name.include? "cover"
      layer_name="cover"
      material_name="cover"
    elsif name.include? "absorbers"
      layer_name="absorbers"
      #the group of absorbers starting from 1 is tungsten; the second group is iron
      if name.include? "_1"
        material_name="tungsten"
      else
        material_name="iron"
      end
    elsif name.include? "scint"
      layer_name="scints"
      material_name="scint"
    elsif name.include? "pcb"
      layer_name="pcb"
      material_name="pcb"
    end
    
    imported_object.layer=model.layers.add(layer_name)
    imported_object.material=model.materials[material_name]
    
    #now smooth internal edges:
    
    #model.start_operation("Soften/Smooth Edges", true)
    
    imported_object.definition.entities.grep(Sketchup::Edge) { |e|
      f = e.faces
      if f[1] && f[0].normal.angle_between(f[1].normal) < 20.degrees
        e.soft=true
        e.smooth=true
      end
    }
    
    #model.commit_operation
    
  end
end

puts "finished importing and processing objects.  Now grouping objects together"

for side in ["left","right"] do
  group=model.entities.add_group(objects_on_sides[side])
  group.name=side
  group.hidden = true
  for object in objects_on_sides[side] do
    object.hidden = false
  end
  group.layer=model.layers.add(side)
  group.hidden = false
end

puts "done!"

model.commit_operation

