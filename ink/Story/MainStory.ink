INCLUDE init.ink
INCLUDE Run1/PrologueOpeningScene.ink
INCLUDE Run1/Day1/AwakeningLana.ink
INCLUDE Run1/Day1/FirstEncounter.ink


Lana(happy): Hey you!




=== start ===
// These are Knot Tags, the commands are done at start, before any other line
# room: courtyard
# music: joyous_exterior
# layout: layout_intimate [lana, machin, truc]

// These are Link Commands
>>> my_command // This is the old way of running every commands
// you could totally write
>>> room courtyard lana, machin, truc
// or for more verbose example
>>> change_room courtyard
// It's still useful for commands that aren't at the beginning of the know 
// And that are not directly linked to a line

// This is a Line Tag, it is read right before the line is written
# sfx: laughing # camera_fx: shake
Lana(happy): Oh I am so *happy* that...</wait> we are going to create **Connect** on ***Godot***! 

// It works the same as
>>> sfx laughing
>>> camera_fx shake
Lana(happy): Oh I am so *happy* that...</wait> we are going to create **Connect** on ***Godot***! 

// These are inline tags </tag>
// These commands are run during display
Lana(happy): Oh I am so happy that...</wait> we are going to create Connect on Godot!</sfx tada> 

-> RUN1_PROLOGUE_OPENING_SCENE
-> DONE // start

// $> increase_affinity lana 1