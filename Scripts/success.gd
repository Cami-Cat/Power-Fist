extends Control
class_name Success_Screen

@onready var player : Player = get_tree().get_first_node_in_group("Player")
@onready var level : Level = get_tree().current_scene

@onready var score: Label = $Panel/SCORE/Value
@onready var time: Label = $Panel/TIME/Value

func _complete_level() -> void:
	score.text = str(level.score)
	time.text = _parse_time(level.time)
	
func _parse_time(input) -> String:
	var m = int(input / 60.0)
	var s = input - m * 60
	return '%02d:%02d' % [m, s]
	
