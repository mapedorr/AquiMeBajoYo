extends KinematicBody2D

export (int) var run_speed = 100

var velocity = Vector2()


func _ready():
	pass # Replace with function body.

func get_input():
	velocity.x = 0
	velocity.y = 0

	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	
	velocity = velocity.normalized() * run_speed
	

func _physics_process(delta):
	get_input()
	#velocity = move_and_slide(velocity)
	var collision_info = move_and_collide(velocity * delta)
	if collision_info and collision_info.collider.is_in_group('Animals'):
		var collision_point = collision_info.position
		collision_info.collider.add_force(-collision_info.normal*run_speed)

