extends KinematicBody2D

export (int) var base_speed = 100

var velocity = Vector2()
var acceleration = 10
var run_speed = base_speed

var increased = 0


func _ready():
	pass # Replace with function body.

func get_input():
	var local_speed = Vector2()
	
	if Input.is_action_just_pressed('ui_right') or Input.is_action_just_pressed('ui_left') or Input.is_action_just_pressed('ui_up') or Input.is_action_just_pressed('ui_down'):
		increased += 50
		$CollisionShape.shape.radius -= 1.3
		if $CollisionShape.shape.radius < 10:
			$CollisionShape.shape.radius = 10
	else:
		increased = increased*0.9
		$CollisionShape.shape.radius += 0.2
		if increased <= 0:
			increased = 0
		if $CollisionShape.shape.radius >= 43:
			$CollisionShape.shape.radius = 43

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
		velocity = local_speed.normalized() * base_speed
	
		$Sprite.rotation = velocity.angle()-PI/2


func _physics_process(delta):
	get_input()
	#velocity = move_and_slide(velocity)
	var collision_info = move_and_collide(velocity * delta)
	if collision_info and collision_info.collider.is_in_group('Animals'):
		
		collision_info.collider.add_force(-collision_info.normal*(run_speed+increased))
		velocity += (velocity.normalized()+collision_info.normal)*run_speed*0.1

