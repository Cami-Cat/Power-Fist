extends CollisionShape3D
class_name Kill_Area

@onready var parent = $"../.."
@onready var player : Player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	pass

func _kill() -> void:
	parent._kill()
