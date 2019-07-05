extends CanvasLayer

var bus_steps = 0
var bus_end_pos = 744.0
var action_to_start = "clic"
onready var bus_icon_origin = $Travel/BusIcon.get_position()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Doors.hide()

	if OS.has_touchscreen_ui_hint():
		action_to_start = "tap"

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
	$TextLayer/Legend.text = "Casi no me bajo!"
	$TextLayer/Continue.text = "Haz " + action_to_start + " para continuar"
	$TextLayer/Continue.modulate = Color("ff477d")
	$TextLayer.show()
	$win.show()

func lose():
	$TextLayer/Legend.text = "Se me pasó la estación"
	$TextLayer/Continue.text = "Haz " + action_to_start + " para reintentar"
	$TextLayer/Continue.modulate = Color("ffe36c")
	$TextLayer.show()
	$lose.show()

func _on_Progress_value_changed(value):
	var bus_pos = $Travel/BusIcon.get_position()
	$Travel/BusIcon.set_position(Vector2(bus_pos.x + bus_steps, bus_pos.y))

func show_station():
	$Display/AnimationPlayer.stop()
	$Display/Control/StopName.set_text("RICAURTE")
	$Display/Control/StopName.set_position(Vector2(-38.0, 16.0))

func restart():
	$win.hide()
	$lose.hide()
	$TextLayer.hide()
	$Doors.hide()

	$Display/AnimationPlayer.stop(true)
	$Display/AnimationPlayer.seek(0.0, true)
	$Travel/Progress.value = 0
	$Travel/BusIcon.set_position(bus_icon_origin)
	$Display/Control/StopName.set_text("Próxima parada: RICAURTE")