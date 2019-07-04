extends Node2D
signal exit_entered

var Marrano = preload("res://scenarios/Animals/Marrano.tscn")
var Vaca = preload("res://scenarios/Animals/Animal.tscn")


# The time it takes the bus to arrive at the station (in segundos)
var travel_time = 20
# The time the bus keeps its doors opened (in segundos)
var doors_time = 30
var default_params = {
	"travel_time": 20,
	"doors_time": 30,
	"spawn_area": "spawnCenter",
	"vacas": {
		"back": 1,
		"center": 2,
		"front": 1
	},
	"marranos": {
		"back": 2,
		"center": 0,
		"front": 2
	}
}
# Called when the node enters the scene tree for the first time.
func _ready():
	$Spawn.hide()
	$Target/Area2D.connect("body_entered", self, "target_entered")
	self.load_level(default_params)

func load_level(params):
	
	spanAnimal(Vaca, $areas/back, params['vacas']['back'])
	spanAnimal(Vaca, $areas/center, params['vacas']['center'])
	spanAnimal(Vaca, $areas/front, params['vacas']['front'])
	spanAnimal(Marrano, $areas/back, params['marranos']['back'])
	spanAnimal(Marrano, $areas/center, params['marranos']['center'])
	spanAnimal(Marrano, $areas/front, params['marranos']['front'])
	
	travel_time = params['travel_time']
	doors_time = params['doors_time']
	
	var areaToSpawn = $areas.get_node(params['spawn_area'])
	$Spawn.position = getRandomPositionOnRect(getRectForArea(areaToSpawn))
	

func spanAnimal(animal, side, total):
	var rect = getRectForArea(side)
	for i in range(0, total):
		var newAnimal = animal.instance()
		newAnimal.position = getRandomPositionOnRect(rect)
		$Animals.add_child(newAnimal)


func getRectForArea(side):
	var extents = side.shape.extents
	var position = side.position
	return Rect2(
		position.x - extents.x,
		position.y - extents.y,
		extents.x*2,
		extents.y*2
	)

func getRandomPositionOnRect(rect):
	var xpos = rect.position.x + randi()%int(rect.size.x)
	var ypos = rect.position.y + randi()%int(rect.size.y)
	return Vector2(xpos, ypos)


func target_entered(body):
	emit_signal("exit_entered", body)

func open_doors():
	for door in $Doors.get_children():
		door.open()
	
	for doorsfx in $SFXDoors.get_children():
		doorsfx.playsound()