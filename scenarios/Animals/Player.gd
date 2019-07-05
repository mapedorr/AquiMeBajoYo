extends KinematicBody2D

export (int) var base_speed = 100
export (int) var VxWeight 

var velocity = Vector2()
var run_speed = base_speed
var canPlay = true
var gamerunning


var increased = 0
var on_pressed = false
var just_pressed = false
var input_position = Vector2(0, 0)


func _ready():
	gamerunning = true

func decrease_size():
	increased += 40
	$CollisionShape.shape.radius -= 1.0
	$Sprite.scale.x -= 0.025
	if $CollisionShape.shape.radius < 8:
		$CollisionShape.shape.radius = 8
	if $Sprite.scale.x < 0.3:
		$Sprite.scale.x = 0.3

func increase_size():
	increased = increased*0.9
	$CollisionShape.shape.radius += 0.15
	$Sprite.scale.x += 0.005
	if increased <= 0:
		increased = 0
	if $CollisionShape.shape.radius >= 40:
		$CollisionShape.shape.radius = 40
	if $Sprite.scale.x > 1.0:
		$Sprite.scale.x = 1.0

func get_input(delta):
	
	var local_speed = Vector2()

	if Input.is_action_pressed('ui_right'):
		local_speed.x += 1
	if Input.is_action_pressed('ui_left'):
		local_speed.x -= 1
	if Input.is_action_pressed('ui_up'):
		local_speed.y -= 1
	if Input.is_action_pressed('ui_down'):
		local_speed.y += 1

	if Input.is_action_just_pressed('ui_right') or Input.is_action_just_pressed('ui_left') or Input.is_action_just_pressed('ui_up') or Input.is_action_just_pressed('ui_down') or self.just_pressed:
		self.decrease_size()
	else:
		self.increase_size()
	
	if self.on_pressed:
		local_speed = self.input_position - self.global_position
		if local_speed.length() < 10:
			local_speed = Vector2(0, 0)
	
	
	if self.just_pressed:
		self.just_pressed = false
	
	if local_speed.length() == 0:
		velocity = Vector2()
	else:
		velocity = local_speed.normalized() * base_speed
	
		$Sprite.rotation = velocity.angle()-PI/2


func _physics_process(delta):
	get_input(delta)
	#velocity = move_and_slide(velocity)
	var collision_info = move_and_collide(velocity * delta)
	if collision_info and collision_info.collider.is_in_group('Animals'):
		
		playGoat()
		collision_info.collider.add_force(-collision_info.normal*(run_speed+increased))
		velocity += (velocity.normalized()+collision_info.normal)*run_speed*0.1

func _input(event):
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		self.on_pressed = event.pressed
		if self.on_pressed:
			self.decrease_size()
			self.just_pressed = true
		
		if event is InputEventMouseButton:
			input_position = $Camera2D.get_global_mouse_position()
		
		if event is InputEventScreenTouch:
			input_position = $Camera2D.get_canvas_transform().xform_inv(event.position)

	if event is InputEventScreenDrag:
		input_position = $Camera2D.get_canvas_transform().xform_inv(event.position)
	if event is InputEventMouseMotion:
		input_position = $Camera2D.get_global_mouse_position()

func playGoat():
	if gamerunning:
		if canPlay:
			var randomNumber = randi()%100
			if randomNumber <= VxWeight:
				$SFX_Goat.playsound()
				canPlay = false
				yield(get_tree().create_timer(4), "timeout")
				canPlay = true
			