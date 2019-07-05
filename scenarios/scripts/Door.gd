extends StaticBody2D

export(bool) var is_left = true

func open():
	if is_left:
		self.open_left()
	else:
		self.open_right()

func open_left():
	$AnimationPlayer.play("OpenLeft")

func open_right():
	$AnimationPlayer.play("OpenRight")

func close():
	$AnimationPlayer.stop()
	$AnimationPlayer.seek(0.0, true)