extends Node2D

signal exit_entered

# Called when the node enters the scene tree for the first time.
func _ready():
	$Spawn.hide()
	$Target/Area2D.connect("body_entered", self, "target_entered")

func target_entered(body):
	emit_signal("exit_entered", body)