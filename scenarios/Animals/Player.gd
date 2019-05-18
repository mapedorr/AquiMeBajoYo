extends KinematicBody2D

export (int) var run_speed = 100

var velocity = Vector2()
var acceleration = 10


func _ready():
	pass # Replace with function body.

func get_input():
	var local_speed = Vector2()


	if Input.is_action_pressed('ui_right'):
		local_speed.x += 1
	if Input.is_action_pressed('ui_left'):
		local_speed.x -= 1
	if Input.is_action_pressed('ui_up'):
		local_speed.y -= 1
	if Input.is_action_pressed('ui_down'):
		local_speed.y += 1
	
	if local_speed.length() == 0:
		velocity = Vector2()
	else:
		#velocity = local_speed*run
		#if velocity.length()>run_speed:
		velocity = local_speed.normalized() * run_speed
	
		$Sprite.rotation = velocity.angle()-PI/2


func _physics_process(delta):
	get_input()
	#velocity = move_and_slide(velocity)
	var collision_info = move_and_collide(velocity * delta)
	if collision_info and collision_info.collider.is_in_group('Animals'):
		
		collision_info.collider.add_force(-collision_info.normal*run_speed)
		velocity += (velocity.normalized()+collision_info.normal)*run_speed*0.1

