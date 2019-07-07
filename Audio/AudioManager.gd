extends Node

export (int) var current_estacion

func _on_Bus_Brake_finished():
	$Bus_Idle.play()

func proximaparada():
	$SFX_PP.play()
	change_station()
	
func change_station():
	$SFX_Estacion.set_station(current_estacion)