extends Node2D

export(bool) var debugging = false

onready var secs = 0
onready var elapsed_secs = 0
onready var doors_open = false
onready var _ui = $UI
onready var win = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.position = $Bus/Spawn.get_position()
	$Bus.connect("exit_entered", self, "finish_level")
	# Setup the timers
	self.setup_time()

func _process(delta):
	if secs == 30:
		$Mx.value = 0.2
		$Mx.speedUp()
		
	elif secs == 15:
		$Mx.value = 0.4
		$Mx.speedUp()

func finish_level(body):
	if body.name == "Player":
		$Mx.stop()
		$Mx_Win.play()
		$Travel.stop()

	# Check if we're debugging
	if debugging:
		$Debug.show()


func setup_time():
	secs = $Bus.travel_time + $Bus.doors_time
	if debugging:
		$Debug/GameTime.set_text("%02d" % secs)
	_ui.initialize($Bus.travel_time, $Bus.doors_time)
	# Listen signals and start the timer
	$Travel.connect("timeout", self, "travel_timeout")
	$Travel.start()

func travel_timeout():
	# Update the UI
	if not doors_open:
		_ui.update_travel_progress()
	else:
		_ui.update_doors_progress()

	secs -= 1
	if secs == 0:
		$Travel.stop()
		print("You are a loser")
	elapsed_secs += 1
	if elapsed_secs == $Bus.travel_time:
		doors_open = true
		var x = $Background/BackgroundAnimation.current_animation_position
		$Background/BackgroundAnimation.set_speed_scale(0)
	
	if elapsed_secs == $Bus.travel_time - 3:
		$Background/Station.show()
		$Background/StationAnimation.play("Arrival")
		$Background/BackgroundAnimation.set_speed_scale(0.5)

	if debugging:
		$Debug/GameTime.set_text("%02d" % secs)
