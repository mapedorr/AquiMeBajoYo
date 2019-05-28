extends Node2D

onready var secs = 0
onready var elapsed_secs = 0
onready var doors_open = false
onready var _ui = $UI
onready var win = false
onready var started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect signal listeners
	$Cover/Background.connect("gui_input", self, "start")
	$UI/lose.connect("button_down", self, 'restart')
	$UI/win.connect("button_down", self, 'restart')

func start(event):
	if event.is_pressed():
		$Cover/Background.hide()
		$AudioManager/Bus_Drive.play()
		$AudioManager/Bus_Drive/Bumps.idleMoo()
		$Player.position = $Bus/Spawn.get_position()
		$Bus.connect("exit_entered", self, "finish_level")
		# Setup the timers
		self.setup_time()
		# Update the flag that indicates the game has started
		started = true

func restart():
	get_tree().reload_current_scene()

func _process(delta):
	if not started:
		return
	if secs == 30:
		$Mx.value = 0.2
		$Mx.speedUp()
		
	elif secs == 15:
		$Mx.value = 0.4
		$Mx.speedUp()

func finish_level(body):
	if body.name == "Player":
		$Player.gamerunning = false
		$Bus/Animals.stopAnimals()
		$Mx.stop()
		$Mx_Win.play()
		$Travel.stop()
		$AudioManager/Bus_Idle.stop()
		$UI.win()

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
		$Travel.stop()
		$Bus/Animals.stopAnimals()
		$Player.gamerunning = false
		$UI.lose()
		$Mx.stop()
		$AudioManager/Bus_Idle.stop()
		$Mx_Lose.play()
		print("You are a loser")
	elapsed_secs += 1
	if elapsed_secs == $Bus.travel_time:
		# Open the DOORS
		doors_open = true
		var x = $Background/BackgroundAnimation.current_animation_position
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
		$AudioManager/Bus_Drive.stop()
		$AudioManager/Bus_Drive/Bumps.gamerunning = false
		$AudioManager/Bus_Brake.play()
