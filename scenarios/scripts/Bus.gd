extends Node2D

signal exit_entered

# The time it takes the bus to arrive at the station (in segundos)
export(int) var travel_time = 20
# The time the bus keeps its doors opened (in segundos)
export(int) var doors_time = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	$Spawn.hide()
	$Target/Area2D.connect("body_entered", self, "target_entered")

func target_entered(body):
	emit_signal("exit_entered", body)