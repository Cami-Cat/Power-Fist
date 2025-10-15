extends RigidBody3D
class_name Trophy

@onready var level : Level = get_tree().current_scene
@onready var player : Player = get_tree().get_first_node_in_group("Player")
@onready var trophy_base: MeshInstance3D = $"Trophy Base"

func _ready() -> void:
	freeze = true
	_rotate()

func _kill() -> void:
	level._complete_level()
	player._complete_level()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		_kill()

func _rotate() -> void:
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", Vector3(0, 360, 0), 5).set_trans(tween.TRANS_LINEAR)
	await tween.finished
	_rotate()
	
