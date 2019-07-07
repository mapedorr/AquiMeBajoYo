extends Node2D

onready var secs = 0
onready var elapsed_secs = 0
onready var doors_open = false
onready var _ui = $UI
onready var started = false

var Levels = preload("res://levels.gd")
var start_enabled = false
export(int) var current_station_index = 0

var restarting = false

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
	$Cover/Container.connect("gui_input", self, "start")
	$UI/lose.connect("gui_input", self, 'restart')
	$UI/win.connect("gui_input", self, 'restart')
	var action_to_start = "clic"
	if OS.has_touchscreen_ui_hint():
		action_to_start = "tap"
	$Cover/Container/Description.text = "Haz " + action_to_start + " para jugar"
	$Mx.play()
	$AnimationPlayer.connect("animation_finished", self, "enable_start")

func enable_start(animation):
	start_enabled = true

func start(event):
	if start_enabled and event.is_pressed():
		# Hide the start screen
		$Cover/Container.hide()
		#$Cover/Background.hide()
		#$Cover/Description.hide()
		
		init_game()

func init_game():
	# Play animations
	$Background/BackgroundAnimation.play("Platforms")
	$Background/StreetsAnimation.play("Streets")
	$Bus/AnimationPlayer.play("Ride")
	$UI/Display/AnimationPlayer.play("Pass")

	# Play music and SFX
	$AudioManager/Bus_Drive.play()
	var level = Levels.get_station(current_station_index)
	$AudioManager.current_estacion = current_station_index
	$Bus.load_level(level)
	$Player.position = $Bus/Spawn.get_position()
	$Bus.connect("exit_entered", self, "finish_level")

	# Setup the timers
	self.setup_time()

	# Update the flag that indicates the game has started
	started = true

func restart(event):
	if not restarting and event.is_pressed():
		# Set variables to their default value
		elapsed_secs = 0
		secs = 0
		doors_open = false
		started = false
		$Player.gamerunning = true
		$Mx.restart()
		$AudioManager/Bus_Drive.stop()

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
		restarting = true
		yield(get_tree().create_timer(1.0), "timeout")
		$Mx.play()
		init_game()
		_ui.restart()
		restarting = false

func _process(delta):
	print ($UI/Doors/Progress.value)
	if doors_open:
		if $UI/Doors/Progress.value <= 4:
			$Mx.value = 0.4
			$Mx.speedUp()
	if not started:
		return

func finish_level(body = null):
	if body and body.name != "Player": return
	$Travel.stop()
	$Bus/Animals.stopAnimals()
	$Mx.stop()
	$AudioManager/Bus_Idle.stop()
	$Player.gamerunning = false
	$Bus.end_level()
	$Player.position = $Bus/Spawn.get_position()

	if body and body.name == "Player":
		current_station_index += 1
		if current_station_index >= 10:
			current_station_index = 0
		$Mx_Win.play()
		$UI.win(current_station_index)
	else:
		$Mx_Lose.play()
		$UI.lose()


func setup_time():
	secs = $Bus.travel_time + $Bus.doors_time
	_ui.initialize($Bus.travel_time, $Bus.doors_time, $Bus.station_name)
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
		$Mx.value = 0.2
		$Mx.speedUp()
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
		$AudioManager.proximaparada()
		$Mx.set_volume_db(-10)
		$AudioManager/Bus_Drive.stop()
		$AudioManager/Bus_Brake.play()

func _on_SFX_PP_finished():
	$Mx.set_volume_db(-5)
	$AudioManager/SFX_Estacion.play()
