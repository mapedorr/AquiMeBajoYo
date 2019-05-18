extends Node

export (int) var spec_weight = 3
export (int) var wait_time = 3

var idle = true
var canPlay = true

func _ready():
	randomize()

func idleMoo():
	
	var randomNumber = randi()%100
	if randomNumber <= spec_weight:
		$IdleMoo.playsound()
	if idle == true:
		yield(get_tree().create_timer(wait_time), "timeout")
		if canPlay == true:
			self.idleMoo()
