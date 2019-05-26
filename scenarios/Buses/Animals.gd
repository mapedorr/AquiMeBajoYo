extends Node2D

var gamerunning

func _ready():
	gamerunning = true
	

func stopAnimals():
	for animal in get_children():
		animal.silence()
