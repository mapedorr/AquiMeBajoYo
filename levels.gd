extends Node

const ricaurte = {
	"estation": "ricaurte",
	"travel_time": 20,
	"doors_time": 30,
	"spawn_area": "spawnCenter",
	"vacas": {
		"back": 20,
		"center": 10,
		"front": 32
	},
	"marranos": {
		"back": 4,
		"center": 4,
		"front": 4
	}
}

const calle45 = {
	"estation": "calle 45",
	"travel_time": 10,
	"doors_time": 15,
	"spawn_area": "spawnCenter",
	"vacas": {
		"back": 10,
		"center": 2,
		"front": 10
	},
	"marranos": {
		"back": 1,
		"center": 2 ,
		"front": 3
	}
}

const stations = [ricaurte, calle45]

func _ready():
	pass # Replace with function body.

static func get_random_station():
	return stations[randi()%len(stations)]