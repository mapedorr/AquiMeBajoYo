extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Animal.position = $Bus/Spawn.get_position()
	$Bus.connect("exit_entered", self, "finish_level")

func finish_level(body):
	if body.name == "Animal":
		print("Level finished!")