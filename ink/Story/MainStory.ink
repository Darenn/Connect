INCLUDE init.ink
INCLUDE Run1/PrologueOpeningScene.ink
INCLUDE Run1/Day1/AwakeningLana.ink
INCLUDE Run1/Day1/FirstEncounter.ink

CONST NONE = 0
CONST STRAIGHT = 1
CONST CHESS = 2
CONST CROSSWORD = 3
VAR hooperClueType = NONE

>>> change_layout default lana charlie
Lana(happy): Hi! I'm Lana!
Lana(sad): This text is longer because I need to try the different dialog box  size...
Charlie(neutral): My name is Charlie, and I can jump on  different line like I want sss qsdqsd lkjdq sdkjq sdq dlqskjdqlksdj qsd qlksdjql skdjqlsdjqlksd .
>>> change_layout default kendall none noah
Kendall(annoyed): I will die very soon...
Noah: Yes, me too.


=== start ===
// These are Knot Tags, the commands are done at start, before any other line
# room: courtyard
# music: joyous_exterior
# layout: layout_intimate [lana, machin, truc]

// or for more verbose example
>>> change_room courtyard

# sfx: laughing # camera_fx: shake
Lana(happy): Oh I am so _happy_ that...</wait> we are going to create __Connect__ on $Godot$! 

// It works the same as
>>> sfx laughing
>>> camera_fx shake
Lana(happy): Oh no!

// These are inline tags </tag>
// These commands are run during display
Lana(happy): Oh I am so happy that...</wait> we are going to create Connect on Godot!</sfx tada> 

-> RUN1_PROLOGUE_OPENING_SCENE
-> DONE // start

//  Intro
	- 	They are keeping me waiting. 
		*	Hut 14[]. The door was locked after I sat down. 
		I don't even have a pen to do any work. There's a copy of the morning's intercept in my pocket, but staring at the jumbled letters will only drive me mad. 
		I am not a machine, whatever they say about me.

>>> sfx laughing
>>> camera_fx shake

