extends Node

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

const minuto = {
	"estation": "minuto de dios",
	"travel_time": 10,
	"doors_time": 15,
	"spawn_area": "spawnBack",
	"vacas": {
		"back": 15,
		"center": 10,
		"front": 5
	},
	"marranos": {
		"back": 2,
		"center": 1,
		"front": 1
	}
}

const paloquemao = {
	"estation": "paloquemao",
	"travel_time": 23,
	"doors_time": 8,
	"spawn_area": "spawnFrontDoor",
	"vacas": {
		"back": 5,
		"center": 10,
		"front": 17
	},
	"marranos": {
		"back": 1,
		"center": 2,
		"front": 4
	}
}

const sena = {
	"estation": "sena",
	"travel_time": 15,
	"doors_time": 8,
	"spawn_area": "spawnBack",
	"vacas": {
		"back": 3,
		"center": 10,
		"front": 6,
		"backDoor": 2,
		"centerDoor":2
	},
	"marranos": {
		"center": 3
	}
}

const ricaurte = {
	"estation": "ricaurte",
	"travel_time": 20,
	"doors_time": 30,
	"spawn_area": "spawnCenter",
	"vacas": {
		"back": 20,
		"center": 5,
		"centerDoor": 2,
		"front": 32
	},
	"marranos": {
		"back": 4,
		"center": 1,
		"front": 5
	}
}

const banderas = {
	"estation": "banderas",
	"travel_time": 10,
	"doors_time": 40,
	"spawn_area": "spawnFront",
	"vacas": {
		"back": 12,
		"center": 8,
		"frontDoor": 5,
		"centerDoor": 3,
		"front": 32
	},
	"marranos": {
		"back": 3,
		"center": 2
	}
}


const avJimenez = {
	"estation": "avenida jimenez",
	"travel_time": 20,
	"doors_time": 20,
	"spawn_area": "spawnCenter",
	"vacas": {
		"frontDoor": 2,
		"centerDoor": 2,
	},
	"marranos": {
		"back": 16,
		"center": 10,
		"frontDoor": 5,
		"centerDoor": 2,
		"front": 12
	}
}


const calle72 = {
	"estation": "Calle 72",
	"travel_time": 30,
	"doors_time": 18,
	"spawn_area": "spawnBack",
	"vacas": {
		"backDoor": 2,
		"centerDoor": 2,
		"back": 24,
		"center": 15,
		"front": 10
	},
	"marranos": {
		"back": 4,
		"center": 10,
		"front": 4
	}
}

const calle100 = {
	"estation": "Calle 100",
	"travel_time": 18,
	"doors_time": 18,
	"spawn_area": "spawnCenter",
	"vacas": {
		"back": 28,
		"center": 28,
		"front": 36
	},
	"marranos": {
	}
}

const sanmateo = {
	"estation": "san mateo",
	"travel_time": 40,
	"doors_time": 20,
	"spawn_area": "spawnBack",
	"vacas": {
		"backDoor": 2,
		"centerDoor": 2,
		"frontDoor":6,
		"back": 30,
		"center": 24,
		"front": 24
	},
	"marranos": {
		"back": 6,
		"center": 5,
		"front": 4
	}
}

# Calle 45
# Minuto de Dios
# Paloquemao
# SENA
# Ricaurte

# Banderas
# Avenida Jiménez
# Calle 72
# Calle 100
# San Mateo

const stations = [
	calle45,
	minuto,
	paloquemao,
	sena,
	ricaurte,
	banderas,
	avJimenez,
	calle72,
	calle100,
	sanmateo
]

func _ready():
	pass # Replace with function body.

static func get_station(index):
	return stations[index]