extends AudioStreamPlayer

var pitch
var value = 0.2
onready var dft_value = value
onready var dft_volume = get_volume_db()

func _ready():
	pitch = get_pitch_scale()

func speedUp():
	set_pitch_scale(pitch + value)

func restart():
	set_volume_db(dft_volume)
	value = dft_value
	set_pitch_scale(pitch)