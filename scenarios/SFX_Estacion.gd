extends AudioStreamPlayer

export (AudioStreamOGGVorbis) var Calle45
export (AudioStreamOGGVorbis) var Minuto
export (AudioStreamOGGVorbis) var Paloquemao
export (AudioStreamOGGVorbis) var SENA
export (AudioStreamOGGVorbis) var Ricaurte
export (AudioStreamOGGVorbis) var Banderas
export (AudioStreamOGGVorbis) var Jimenez
export (AudioStreamOGGVorbis) var Calle72
export (AudioStreamOGGVorbis) var Calle100
export (AudioStreamOGGVorbis) var Sanmateo


func set_station(current_station):
	match current_station:
		0:
			set_stream(Calle45)
		1:
			set_stream(Minuto)
		2:
			set_stream(Paloquemao)
		3:
			set_stream(SENA)
		4:
			set_stream(Ricaurte)
		5:
			set_stream(Banderas)
		6:
			set_stream(Jimenez)
		7:
			set_stream(Calle72)
		8:
			set_stream(Calle100)
		9:
			set_stream(Sanmateo)
