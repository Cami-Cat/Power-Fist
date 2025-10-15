extends Button
class_name Level_Button

@onready var score: Label = $Score/Value
@onready var time: Label = $Time/Value
@export var levelId : int = 0
@export var levelToOpen : PackedScene
@onready var level: Label = $Level
@export var levelName : String = ""

func _ready() -> void:
	level.text = levelName
	if PlayerSettings.Levels["Levels Complete"].has(levelId):
		var index = PlayerSettings.Levels["Levels Complete"].find(levelId)
		score.text = str(PlayerSettings.Levels["Level Score"][index])
		time.text = _parse_time(PlayerSettings.Levels["Level Time"][index])
	else:
		score.text = "Incomplete"
		time.hide()

func _on_pressed() -> void:
	if levelToOpen != null:
		get_tree().change_scene_to_packed(levelToOpen)


func _parse_time(timeInSeconds : int) -> String:
	var m = int(timeInSeconds / 60.0)
	var s = timeInSeconds - m * 60
	return '%02d:%02d' % [m, s]

func _on_mouse_entered() -> void:
	level.text = "START"

func _on_mouse_exited() -> void:
	level.text = levelName
