extends CanvasLayer
class_name Level_Select

var levelSelectSong : AudioStream = load("res://Assets/Audio/Music/02. BUNNY - Sweet Little Dead Bunny.mp3")

func _ready() -> void:
	MusicPlayer._change_song(levelSelectSong)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("exit"):
		get_tree().change_scene_to_file("res://Scenes/Main_Menu.tscn")

func _on_exit_level_select_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main_Menu.tscn")
