extends Node3D
class_name Level

@export var levelID : int = 0
@onready var countup: Timer = $countup
@export var nextLevel : PackedScene

@export var song : AudioStream = load("res://Assets/Audio/Music/23. VICTOR - The End Of Doom.mp3")

@onready var player : Player = get_tree().get_first_node_in_group("Player")

@export var medalScoreRequirements = {
	"Platinum Score": 0,
	"Gold Score": 0,
	"Silver Score": 0,
	"Bronze Score": 0
	}
@export var medalTimeRequirements = { # In Seconds
	"Platinum Time": 0,
	"Gold Time": 0,
	"Silver Time": 0,
	"Bronze Time": 0
	}

var score : int
var time : int
@export var timeScore : int = 50000

func _ready() -> void:
	MusicPlayer._change_song(song)

func _complete_level() -> void:
	MusicPlayer._change_song(load("res://Assets/Audio/Music/23. VICTOR - The End Of Doom.mp3"))
	score += timeScore
	PlayerSettings._completed_level(self, time, score)


func _on_countup_timeout() -> void:
	time += 1
	timeScore -= (medalTimeRequirements["Platinum Time"])
	var m = int(time / 60.0)
	var s = time - m * 60
	player.counter.text = '%02d:%02d' % [m, s]
