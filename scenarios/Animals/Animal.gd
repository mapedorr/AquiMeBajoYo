extends KinematicBody2D

var velocity = Vector2(0, 0)

func add_force(force):
	velocity = force

func _physics_process(delta):
	velocity = velocity*1
	var collision_info = move_and_collide(velocity*delta)
	if collision_info and collision_info.collider.is_in_group('Animals'):
		var collision_point = collision_info.position
		collision_info.collider.add_force(-collision_info.normal*velocity.length())

