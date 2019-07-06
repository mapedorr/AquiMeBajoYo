extends KinematicBody2D

var velocity = Vector2(0, 0)
var self_destroy = false
export (float) var friction_ration = 0.9
export (float) var max_speed = 500
export (float) var slide_ratio = 0.8
export (float) var transference_ratio = 0.8


func _ready():
	$CowSounds.idleMoo()
	$CowSounds.connect("silenced", self, "suicide")

func add_force(force):
	velocity += force
	if velocity.length()>max_speed:
		velocity = velocity.normalized()*max_speed
		$ojos_locos.visible = true
	else:
		$ojos_locos.visible = false

func _physics_process(delta):
	velocity = velocity*friction_ration
	var collision_info = move_and_collide(velocity*delta)
	if collision_info and collision_info.collider.is_in_group('Animals'):
		collision_info.collider.add_force(-collision_info.normal*velocity.length()*transference_ratio)
		add_force((velocity.normalized()+collision_info.normal)*velocity.length()*slide_ratio)

	if velocity.length()>5:
		rotation += (velocity.angle()-PI/2)*0.01
		
func _process(delta):
	$CowSounds/IdleMoo.transform = transform

func silence():
	$CowSounds.gamerunning = false

func time_to_dead():
	self_destroy = true

func suicide():
	if self_destroy:
		queue_free()