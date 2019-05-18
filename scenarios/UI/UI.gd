extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	$Doors.hide()
	$Display/AnimationPlayer.play("Pass")

func initialize(travel_time, doors_time):
	$Travel/Progress.max_value = travel_time
	$Doors/Progress.max_value = doors_time
	$Doors/Progress.value = doors_time

func update_travel_progress(magnitude = 1):
	$Travel/Progress.value += magnitude

func update_doors_progress(magnitude = 1):
	if not $Doors.visible:
		$Doors.show()
	$Doors/Progress.value -= magnitude