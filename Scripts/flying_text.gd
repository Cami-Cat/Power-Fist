extends Node3D
class_name Flying_Text

var velocity = Vector3(1, -1, 1)
var gravity = Vector3(0, -0.1, 0)
var mass = 2
var score : int 

# Called when the node enters the scene tree for the first time.
func fly() -> void:
	
	$Label3D.text = str(score)
	position += Vector3(0, 1.5, 0)
	var tween = create_tween()
	tween.tween_property($Label3D, "modulate:a", 0.0, 0.7).set_trans(tween.TRANS_LINEAR)
	await tween.finished 
	queue_free()
