extends Control
class_name Death_Screen

@onready var level : Level = get_tree().current_scene
@onready var player : Player = get_tree().get_first_node_in_group("Player")

@onready var score: Label = $Panel/SCORE/Value
@onready var time: Label = $Panel/TIME/Value

@onready var restart: Button = $"Panel/Restart Button"
@onready var levels: Button = $"Panel/Level Select"
@onready var menu: Button = $"Panel/Main Menu"
@onready var next: Button = $"Panel/Next Level"

@onready var settings: Settings = $"../Settings"

@onready var title: Label = $Panel/Title

func _ready() -> void:
	if PlayerSettings.settings["Fullscreen"] == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	settings.connect("settings_closed", _open)

func _open() -> void:
	next.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	match player.state:
		player.PLAYER_STATE.NONE:
			hide()
			return
		player.PLAYER_STATE.DEAD:
			title.text = "You Died"
		player.PLAYER_STATE.COMPLETED:
			next.visible = true
			title.text = "Level Completed"
		player.PLAYER_STATE.PAUSED:
			title.text = "Paused"
	_display_score()
	show()

func _display_score() -> void:
	score.text = str(level.score)
	time.text = _parse_time(level.time)

func _parse_time(input) -> String:
	var m = int(input / 60.0)
	var s = input - m * 60
	return '%02d:%02d' % [m, s]

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("exit"):
		if settings.visible == true:
			settings.hide()
			_open_menu()
			return
		if player.state == player.PLAYER_STATE.PAUSED:
			_close_menu()
			MusicPlayer.stream_paused = false
			$MenuMusic.stream_paused = true
			return
		elif player.state == player.PLAYER_STATE.NONE:
			_open_menu()
			$MenuMusic.play()
			MusicPlayer.stream_paused = true


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_level_select_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/level_select.tscn")

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Main_Menu.tscn")

func _on_next_level_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(level.nextLevel)

func _on_settings_pressed() -> void:
	hide()
	settings._open()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _open_menu() -> void:
	player.state = player.PLAYER_STATE.PAUSED
	_open()
	get_tree().paused = true

func _close_menu() -> void:
	player.state = player.PLAYER_STATE.NONE
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	hide()
	get_tree().paused = false
