extends "res://Audio/SoundObject.gd"

var index_sound = -1
var select_sound
var canplay

export (float) var minOffset = 0
export (float) var MaxOffset = 0
#func _process(delta):
#	if Input.is_action_pressed("ui_right"):
#		if canplay == true:
#			playsound()
#			canplay = false
#	if Input.is_action_just_released("ui_right"):
#		canplay = true



func playsound():
	
	if MaxOffset != 0:
		yield(get_tree().create_timer(rand_range(minOffset, MaxOffset)),"timeout")
	
	randomize()
	index_sound = randi()%get_child_count()
	select_sound = get_child(index_sound)
	var avVolume = select_sound.Volume + Volume
	var avPitch = select_sound.Pitch + Pitch 
	
	if RandomVolume == true:
		select_sound.randomizeVol(avVolume, minVolume, maxVolume)
	else:
		select_sound.set_volume_db(avVolume)
	
	
	if RandomPitch == true:
		select_sound.randomizePitch(avPitch, minPitch, maxPitch)
	#	select_sound.set_pitch_scale((Pitch) + ranPitch)
	else:
		select_sound.set_pitch_scale(avPitch+1)
	select_sound.playsound()
