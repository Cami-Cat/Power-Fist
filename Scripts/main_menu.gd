extends CanvasLayer
class_name Main_Menu

@onready var menuMusic : AudioStream = load("res://Assets/Audio/Music/23. VICTOR - The End Of Doom.mp3")

# Buttons

@onready var start: Button = $"Menu Content/Buttons/Start"
@onready var settings: Button = $"Menu Content/Buttons/Settings"
@onready var quit: Button = $"Menu Content/Buttons/Quit"

# Title

@onready var title_left: Label = $"Menu Content/Title/Title Left"
@onready var title_right: Label = $"Menu Content/Title/Title Right"

func _ready() -> void:
	MusicPlayer._change_song(menuMusic)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$Settings.visible = false
	$Settings.connect("settings_closed", _on_settings_closed)

func _on_start_pressed() -> void:
	var scn : PackedScene = load("res://Scenes/level_select.tscn")
	get_tree().change_scene_to_packed(scn)

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_settings_pressed() -> void:
	$"Menu Content".visible = false
	$Settings._open()

func _on_settings_closed() -> void:
	get_tree().paused = false
	$"Menu Content".visible = true
