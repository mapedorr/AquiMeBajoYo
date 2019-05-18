extends Node2D

onready var secs = 0
onready var elapsed_secs = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.position = $Bus/Spawn.get_position()
	$Bus.connect("exit_entered", self, "finish_level")
	# Setup the timers
	self.setup_time()

func finish_level(body):
	if body.name == "Player":
		print("Level finished!")

func setup_time():
	secs = $Bus.travel_time + $Bus.doors_time
	$UI/GameTime.set_text("%02d" % secs)
	$Travel.connect("timeout", self, "travel_timeout")
	$Travel.start()

func travel_timeout():
	secs -= 1
	elapsed_secs += 1
	if elapsed_secs == $Bus.travel_time:
		$UI/GameTime.add_color_override("font_color", Color(1, 0, 0, 1))
	if secs == 0:
		$Travel.stop()
		print("The game has finished")
	$UI/GameTime.set_text("%02d" % secs)
