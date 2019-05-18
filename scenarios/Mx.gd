extends AudioStreamPlayer

var pitch
var value = 0.2

func _ready():
	pitch = get_pitch_scale()

func speedUp():
	set_pitch_scale(pitch + value)
