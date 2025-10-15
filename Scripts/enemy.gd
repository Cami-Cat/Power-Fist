extends CharacterBody3D
class_name Enemy

@onready var enemy: CharacterBody3D = $"."
@onready var audio: AudioStreamPlayer3D = $Audio
@onready var sprite: AnimatedSprite3D = $Sprite

@export var moveSpeed : float = 2.0
@export var attackRange : float = 2.0
@export var scoreGiven : int = 250

@onready var flyingScore : PackedScene = load("res://Scenes/flying_text.tscn")
@onready var player : Player = get_tree().get_first_node_in_group("Player")
@onready var level : Level = get_tree().current_scene
var dead : bool = false

func _physics_process(_delta: float) -> void:

	if dead:
		return
	if player == null:
		return

	if !_player_in_line_of_sight():
		return

	var dir = player.global_position - global_position
	dir.y = 0.0
	dir = dir.normalized()
	velocity = dir * moveSpeed
	move_and_slide()
	_attack()

func _kill() -> void:
	var scn : Flying_Text = flyingScore.instantiate()
	self.get_parent().add_child(scn)
	scn.global_position = global_position
	scn.score = scoreGiven
	scn.fly()
	level.score += scoreGiven
	dead = true
	audio.play()
	sprite.play("Death")
	$"Capsule Collision".set_deferred("disabled", true)

func _player_in_line_of_sight() -> bool:
	var eye_line = Vector3.UP * 1.5
	var query = PhysicsRayQueryParameters3D.create(global_position+eye_line, player.global_position+eye_line, 1)
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	if result.is_empty():
		return true
	else:
		return false

func _attack() -> void:
	var distToPlayer = global_position.distance_to(player.global_position)
	if distToPlayer > attackRange:
		return
	if _player_in_line_of_sight():
		player._kill()
	
	
	
