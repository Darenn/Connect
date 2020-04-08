== RUN1_PROLOGUE_OPENING_SCENE ==
>>> play_music prologue_music
>>> change_room prologue_room
>>> change_layout layout_prologue
>>> play_sfx giggle1 1
Voice: 	...
Voice: Can you hear me?
	+ [p: I can hear you...]
	    Voice: Good.
  	+ [p: Who...are you?]
		Voice: I'm the one asking questions here.
- Voice: But let's start with the basics.
    Do you remember your name?

P:(My...name?)
>>> show_name_input_field
>>> play_sfx giggle2 1
Voice: So what? You don't even remember your name?
    How miserable...
    Fine, I'll give you a name myself.
    From now on your name will be Void. 
    Got it? Void?
    Now for the next level...can you remember who you are?
P:(Who...I am...)
// TODO INCREASING HEARTBEATS + PULSATING SCREEN#
	+ [p:It hurts...]
	+ [p:There's nothing...]

- Voice: Figures.
    Don't panic. You don't need to push yourself too hard.
	Everything will come back to you in due time.

// TODO FADE OUT PULSE + HEARTBEAT#

Voice:Now listen closely...
    For I will not repeat myself.
    You and I...
    We are going to play a little game, okay?
>>> play_sfx giggle3 1
Voice: ...Or rather...you're going to take part in a trial.
    Let's put it in simple terms
    There will be no escape, no way out.
    In four weeks, when the last speck of time drains away, I will return.
    Then...you shall be judged.
    Only then will I decide if your trial was a success...
    ...and if you deserve to be released.
    Now, it's up to you to use this information to your heart's desire.
    I can't wait to see where this path will lead you this time...
    Now, go.
    I'll see you in four weeks.
    But remember...
>>> play_sfx giggle4 1
Voice:	I'll always be watching...
-> RUN1_DAY1_AWAKENING_LANA
-> DONE // RUN1_PROLOGUE_OPENING_SCENE