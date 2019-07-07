extends Node2D
signal exit_entered

var Marrano = preload("res://scenarios/Animals/Marrano.tscn")
var Vaca = preload("res://scenarios/Animals/Animal.tscn")


# The time it takes the bus to arrive at the station (in segundos)
var travel_time = 20
# The time the bus keeps its doors opened (in segundos)
var doors_time = 30
var default_params = {
	"estation": "ricaurte",
	"travel_time": 20,
	"doors_time": 30,
	"spawn_area": "spawnCenter",
	"vacas": {
	},
	"marranos": {
	}
}
var station_name = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	$Spawn.hide()
	$Target/Area2D.connect("body_entered", self, "target_entered")
	self.load_level(default_params)

func load_level(params):
	for area in params['vacas'].keys():
		spanAnimal(Vaca, $areas.get_node(area), params['vacas'][area])

	for area in params['marranos'].keys():
		spanAnimal(Marrano, $areas.get_node(area), params['marranos'][area])
	
	travel_time = params['travel_time']
	doors_time = params['doors_time']
	station_name = params['estation']
	
	
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

func end_level():
	for door in $Doors.get_children():
		door.close()
	for animal in $Animals.get_children():
		animal.time_to_dead()
		$Animals.remove_child(animal)