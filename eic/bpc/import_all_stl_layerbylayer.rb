#Run this in the ruby console.  And then go to bed with the laptop running.

#  load "/Users/spaul/Documents/Google Sketchup/DetectorsSketchupUCR/eic/bpc/import_all_stl_layerbylayer.rb"

require 'sketchup.rb'

dir="/Users/spaul/Documents/Google Sketchup/DetectorsSketchupUCR/eic/bpc/"

object_names = ["hexscint", "absorbers", "covers", "pcb"]

#object_names=["covers", "pcb_1-7"]

model=Sketchup.active_model


time1 = Time.new
puts "Start time: " + time1.inspect

objects_on_sides= {}
objects_on_sides["left"] = []
objects_on_sides["right"] = []

model.start_operation("Import stuff", true) 

for name in object_names do
  for side in ["left","right"] do
    for i in 0..50 do

      #layer 50 is absorber only
      if i == 50 and name != "absorber"
        next
      end
      
      if name == "covers"
        layer_name="cover"
        material_name="cover"
      elsif name == "absorbers"
        layer_name="absorbers"
        if i <= 20 
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

      
      filename = dir+"openscad/output_stl/" + name+"_"+i.to_s+"_" + side + ".stl"
      puts "[" +Time.new.inspect + "] begin import "+filename

      model.import(filename)

      puts "[" +Time.new.inspect + "] finished import " + filename + "\n now processing"

      imported_object = Sketchup.active_model.entities[-1]
      imported_object.hidden = true
      objects_on_sides[side] << imported_object
      
      imported_object.layer=model.layers.add(layer_name)
      imported_object.material=model.materials[material_name]
      
      #now smooth internal edges:
      
      #model.start_operation("Soften/Smooth Edges", true)
      cos35=Math.cos(35.degrees)
      imported_object.definition.entities.grep(Sketchup::Edge) { |e|
        f = e.faces
        #if !(e.soft? && e.smooth?) && f[1] && f[0].normal.angle_between(f[1].normal) < 20.degrees
        if !(e.soft? && e.smooth?) && f[1] && f[0].normal.dot(f[1].normal) > cos35   
          e.soft=true
          e.smooth=true
        end
      }
      
      #model.commit_operation
    end
  end
end

puts "[" +Time.new.inspect + "] finished importing and processing objects.  Now grouping objects together"

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

puts "[" +Time.new.inspect + "] done!"

model.commit_operation

