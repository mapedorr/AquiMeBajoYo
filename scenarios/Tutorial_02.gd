extends Control

var cows_pos = []
signal close_me
var emited = false

func _ready():
	for vaca in $vacas.get_children():
		cows_pos.append(vaca.position)
	connect("gui_input", self, "check_close")
	$Player/Camera2D.current = false
	#start()

func start():
	$AnimationPlayer.connect("animation_finished", self, "play_one")
	play_one('whatever')

func play_one(animation_name):
	var i = 0
	for vaca in $vacas.get_children():
		vaca.position = cows_pos[i]
		i += 1
	$AnimationPlayer.play("touchs")

func check_close(event):
	if not emited and event.is_pressed():
		emit_signal("close_me")
		emited = true