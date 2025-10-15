extends Area3D
class_name Pickup

enum PickType {NONE, RANGE, SPEED, DAMAGE}

@onready var audio: AudioStreamPlayer3D = $Audio
@onready var sprite : Sprite3D = $"Pickup Item"

@export var pickUpType = PickType.NONE
@export var increaseValue : float = 0.0
@export var pickupScore : int = 1000

@onready var player: Player = get_tree().get_first_node_in_group("Player")
@onready var level : Level = get_tree().current_scene

func _ready() -> void:
	match pickUpType:
		PickType.NONE:
			queue_free()
		PickType.RANGE:
			var rangeSprite = load("res://Assets/Sprites/punch_03.png")
			sprite.texture = rangeSprite
			return
		PickType.SPEED:
			pass
		PickType.DAMAGE:
			pass

func _on_body_entered(body: Node3D) -> void:
	if body is not Player:
		return
	match pickUpType:
		PickType.RANGE:
			var scn : PackedScene = load("res://Scenes/flying_text.tscn")
			var flyingText = scn.instantiate()
			self.add_child(flyingText)
			flyingText.global_position = global_position
			flyingText.score = pickupScore
			flyingText.fly()
			player.cast.target_position *= increaseValue
		PickType.SPEED:
			player.SPEED += increaseValue
		PickType.DAMAGE:
			pass
	audio.play()
	level.score += pickupScore
	sprite.visible = false
	$CollisionShape3D.set_deferred("disabled", true)
