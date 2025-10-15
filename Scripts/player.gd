extends CharacterBody3D
class_name Player

@onready var fistSprite : AnimatedSprite2D = $CanvasLayer/Fist/FistSprite
@onready var cast : RayCast3D = $Cast
@onready var audio : AudioStreamPlayer = $Audio
@onready var counter : Label = $CanvasLayer/Counter/Label
@onready var menu: Death_Screen = $CanvasLayer/Menu

var SPEED : float = 10.0
const MOUSE_SENS : float = 0.2

enum PLAYER_STATE {NONE, DEAD, PAUSED, COMPLETED}
var state = PLAYER_STATE.NONE

var canShoot : bool = true
var dead : bool = false
var colliding : bool = false

func _ready() -> void:
	# Hides cursor and sticks it to center of screen
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	fistSprite.animation_finished.connect(_attack_finished)

func _input(event) -> void:
	if dead:
		return
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * MOUSE_SENS

func _process(_delta: float) -> void:
	if dead:
		return
	if Input.is_action_just_pressed("attack"):
		_attack()

func _physics_process(_delta: float) -> void:

	if dead:
		return

	if cast.is_colliding() && colliding == false:
		_change_crosshair() 
	elif !cast.is_colliding():
		_return_crosshair()

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func _attack() -> void:
	if !canShoot:
		return
	canShoot = false
	fistSprite.play("Attack")
	audio.stream = load("res://Assets/Audio/MS-DOS - DOOM DOOM II - Sound Effects/Throw_Punch.wav")
	audio.play()
	if cast.is_colliding() and cast.get_collider().has_method("_kill"):
		cast.get_collider()._kill()
		audio.stream = load("res://Assets/Audio/MS-DOS - DOOM DOOM II - Sound Effects/Punch_Land.wav")
		audio.play()

func _attack_finished() -> void:
	canShoot = true

func _kill() -> void:
	MusicPlayer._change_song(load("res://Assets/Audio/Music/23. VICTOR - The End Of Doom.mp3"))
	dead = true
	state = PLAYER_STATE.DEAD
	menu._open()
	get_tree().paused = true

func _complete_level() -> void:
	state = PLAYER_STATE.COMPLETED
	menu._open()
	get_tree().paused = true

func _change_crosshair() -> void:
	colliding = true
	var crosshair: ColorRect = $CanvasLayer/Crosshair
	crosshair.color = Color.RED
	var tween = create_tween()
	tween.tween_property(crosshair, "rotation_degrees", 45, 0.1).set_trans(tween.TRANS_LINEAR)

func _return_crosshair() -> void:
	colliding = false
	var crosshair: ColorRect = $CanvasLayer/Crosshair
	crosshair.color = Color.ALICE_BLUE
	var tween = create_tween()
	tween.tween_property(crosshair, "rotation_degrees", 0, 0.1).set_trans(tween.TRANS_LINEAR)
