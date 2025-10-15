extends RigidBody3D
class_name Door

@onready var player : Player = get_tree().get_first_node_in_group("Player")
@onready var killBox: CollisionShape3D = $Area3D/KillBox
@onready var flyingScore : PackedScene = load("res://Scenes/flying_text.tscn")
@onready var level : Level = get_tree().current_scene
@onready var audio: AudioStreamPlayer3D = $Audio

@export var hitSound : AudioStream = load("res://Assets/Audio/MS-DOS - DOOM DOOM II - Sound Effects/Hit_Door.wav")

@export var force : float = 250
@export var scoreGiven : int
var forceMultiplier : float = -10
var hit : bool = false

func _ready() -> void:
	force *= forceMultiplier
	killBox.disabled = true
	freeze = true

func _kill() -> void:
	if hit:
		return
	audio.play()
	hit = true
	var scn : Flying_Text = flyingScore.instantiate()
	self.get_parent().add_child(scn)
	scn.global_position = global_position
	scn.score = scoreGiven
	scn.fly()
	level.score += scoreGiven
	_enable_self()
	_knockback()
	
func _on_area_3d_body_entered(body) -> void:
	if body is Enemy:
		if body.dead == true:
			return
		body._kill()

func _enable_self() -> void:
	$Collision.disabled = true
	killBox.disabled = false
	freeze = false
	await get_tree().create_timer(0.05).timeout
	$Collision.disabled = false

func _knockback() -> void:
	var impulse = ((player.global_position.direction_to(global_position) * force) * -1)
	var normal = player.cast.get_collision_normal()
	apply_impulse(impulse, normal)
	await get_tree().create_timer(0.5).timeout
	set_collision_mask_value(2, false)
	killBox.disabled = true
	_fade(1.5, 0.5)

func _fade(delay : float, length : float) -> void:
	await get_tree().create_timer(delay).timeout
	$Collision.disabled = true
	var tween = create_tween()
	tween.tween_property($Mesh, "transparency", 1, length)
	await tween.finished
	queue_free()
