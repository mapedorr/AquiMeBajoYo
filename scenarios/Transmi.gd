extends Node2D

onready var secs = 0
onready var elapsed_secs = 0
onready var doors_open = false
onready var _ui = $UI
onready var started = false

var Levels = preload("res://levels.gd")

var default_level = {
	"travel_time": 20,
	"doors_time": 30,
	"spawn_area": "spawnCenter",
	"vacas": {
		"back": 1,
		"center": 2,
		"front": 1
	},
	"marranos": {
		"back": 2,
		"center": 0,
		"front": 2
	}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect signal listeners
	$Cover/Background.connect("gui_input", self, "start")
	$UI/lose.connect("gui_input", self, 'restart')
	$UI/win.connect("gui_input", self, 'restart')
	var action_to_start = "clic"
	if OS.has_touchscreen_ui_hint():
		action_to_start = "tap"
	$Cover/Description.text = "Haz " + action_to_start + " para jugar"
	$Mx.play()


func start(event):
	if event.is_pressed():
		# Hide the start screen
		$Cover/AnimatedSplash.hide()
		$Cover/Background.hide()
		$Cover/Description.hide()
		
		# Play animations
		$Background/BackgroundAnimation.play("Platforms")
		$Background/StreetsAnimation.play("Streets")
		$Bus/AnimationPlayer.play("Ride")
		$UI/Display/AnimationPlayer.play("Pass")

		# Play music and SFX
		$AudioManager/Bus_Drive.play()
		var level = Levels.get_random_station()
		$Bus.load_level(level)
		$Player.position = $Bus/Spawn.get_position()
		$Bus.connect("exit_entered", self, "finish_level")

		# Setup the timers
		self.setup_time()

		# Update the flag that indicates the game has started
		started = true

func restart(event):
	if event.is_pressed():
		# Set variables to their default value
		elapsed_secs = 0
		secs = 0
		doors_open = false
		win = false
		started = false
		$Player.gamerunning = true
		$Bus.close_doors()
		$Mx.restart()
		$AudioManager/Bus_Drive.stop()
		_ui.restart()
		$Player.position = $Bus/Spawn.get_position()

		# Disconnect signals
		$Bus.disconnect("exit_entered", self, "finish_level")
		$Travel.disconnect("timeout", self, "travel_timeout")

		# Set animations to their default state
		$Background/Station.hide()
		$Background/BackgroundAnimation.stop()
		$Background/StreetsAnimation.stop()
		$Background/StationAnimation.stop()
		$Background/BackgroundAnimation.set_speed_scale(1.0)
		$Background/StreetsAnimation.set_speed_scale(1.0)
		$Bus/AnimationPlayer.stop()

		# Show the start screen
		$Cover/AnimatedSplash.show()
		$Cover/Background.show()
		$Cover/Description.show()
		$Mx.play()

func _process(delta):
	if not started:
		return
	if secs == 30:
		$Mx.value = 0.2
		$Mx.speedUp()
		
	elif secs == 15:
		$Mx.value = 0.4
		$Mx.speedUp()

func finish_level(body = null):
	$Travel.stop()
	$Bus/Animals.stopAnimals()
	$Mx.stop()
	$AudioManager/Bus_Idle.stop()
	$Player.gamerunning = false

	if body and body.name == "Player":
		$Mx_Win.play()
		$UI.win()
	else:
		$Mx_Lose.play()
		$UI.lose()

func setup_time():
	secs = $Bus.travel_time + $Bus.doors_time
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
		finish_level()
		return

	elapsed_secs += 1
	if elapsed_secs == $Bus.travel_time:
		# Open the DOORS
		doors_open = true
		$Background/BackgroundAnimation.set_speed_scale(0)
		$Background/StreetsAnimation.set_speed_scale(0)
		$Bus.open_doors()
		_ui.show_station()
	
	if elapsed_secs == $Bus.travel_time - 3:
		$Background/Station.show()
		$Background/StationAnimation.play("Arrival")
		$Background/BackgroundAnimation.set_speed_scale(0.5)
		$Background/StreetsAnimation.set_speed_scale(0.5)
	
	if elapsed_secs == $Bus.travel_time - 6:
		$AudioManager/SFX_PP.play()
		$Mx.set_volume_db(-10)
		$AudioManager/Bus_Drive.stop()
		$AudioManager/Bus_Brake.play()

func _on_SFX_PP_finished():
	$Mx.set_volume_db(-5)
