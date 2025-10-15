extends AudioStreamPlayer

var currentSong : AudioStream = load("res://Assets/Audio/Music/23. VICTOR - The End Of Doom.mp3")

func _change_song(newSong : AudioStream) -> void:
	if newSong.resource_path == currentSong.resource_path:
		return
	currentSong = newSong
	stream = newSong
	play()
