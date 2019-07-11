tool
extends Node2D

func _ready():
	$down.visible = false
	$up.visible = true

func press():
	$AnimationPlayer.play("keep press")

func relase():
	$AnimationPlayer.play("release")

func simple_touch():
	$AnimationPlayer.play("simple touch")

func keep_touching():
	$AnimationPlayer.play("touch")