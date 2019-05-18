extends Node2D

export(bool) var debugging = false

onready var secs = 0
onready var elapsed_secs = 0
onready var doors_open = false
onready var _ui = $UI
onready var win = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioManager/Bus_Drive.play()
	$AudioManager/Bus_Drive/Bumps.idleMoo()
	$Player.position = $Bus/Spawn.get_position()
	$Bus.connect("exit_entered", self, "finish_level")
	# Setup the timers
	self.setup_time()
	$UI/lose.connect("button_down", self, 'restart')
	$UI/win.connect("button_down", self, 'restart')

func restart():
	get_tree().reload_current_scene()

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
		$UI.win()

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
		$UI.lose()
		print("You are a loser")
	elapsed_secs += 1
	if elapsed_secs == $Bus.travel_time:
		# Open the DOORS
		doors_open = true
		var x = $Background/BackgroundAnimation.current_animation_position
		$Background/BackgroundAnimation.set_speed_scale(0)
		$Background/StreetsAnimation.set_speed_scale(0)
		$Bus.open_doors()
	
	if elapsed_secs == $Bus.travel_time - 3:
		$Background/Station.show()
		$Background/StationAnimation.play("Arrival")
		$Background/BackgroundAnimation.set_speed_scale(0.5)
		$Background/StreetsAnimation.set_speed_scale(0.5)
	
	if elapsed_secs == $Bus.travel_time - 6:
		$AudioManager/Bus_Drive.stop()
		$AudioManager/Bus_Drive/Bumps.canPlay = false
		$AudioManager/Bus_Brake.play()

	if debugging:
		$Debug/GameTime.set_text("%02d" % secs)
