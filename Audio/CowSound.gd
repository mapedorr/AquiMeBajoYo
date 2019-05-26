extends Node

export (int) var spec_weight = 3
export (int) var min_wt = 3
export (int) var max_wt = 3

var canPlay = true
var wait_time
var gamerunning

func _ready():
	gamerunning = true
	canPlay = true
	



func idleMoo():
	if gamerunning:
		if canPlay == true:
			randomize()
			wait_time = int ((rand_range( min_wt, (max_wt+1))))
			canPlay = false
			yield(get_tree().create_timer(wait_time), "timeout")
			Moo()
			idleMoo()

func Moo():
	if gamerunning:
		randomize()
		var randomNumber = randi()%100
		if randomNumber <= spec_weight+1:
			$IdleMoo.playsound()
		canPlay = true
	