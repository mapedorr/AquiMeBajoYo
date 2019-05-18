extends CanvasLayer

var bus_steps = 0
var bus_end_pos = 744.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Doors.hide()
	$Display/AnimationPlayer.play("Pass")

func initialize(travel_time, doors_time):
	$Travel/Progress.max_value = travel_time
	$Doors/Progress.max_value = doors_time
	$Doors/Progress.value = doors_time
	bus_steps = (bus_end_pos - $Travel/BusIcon.get_position().x) / travel_time

func update_travel_progress(magnitude = 1):
	$Travel/Progress.value += magnitude

func update_doors_progress(magnitude = 1):
	if not $Doors.visible:
		$Doors.show()
	$Doors/Progress.value -= magnitude


func win():
	$win.show()

func lose():
	$lose.show()

func _on_Progress_value_changed(value):
	var bus_pos = $Travel/BusIcon.get_position()
	$Travel/BusIcon.set_position(Vector2(bus_pos.x + bus_steps, bus_pos.y))

