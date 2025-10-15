extends Control
class_name Sliders

@onready var master: HSlider = $"Master Volume"
@export var masterBus : String = "Master"
var masterBusIndex : int = AudioServer.get_bus_index(masterBus)

@onready var sfx: HSlider = $SFX
@export var sfxBus : String = "SFX"
var sfxBusIndex : int = AudioServer.get_bus_index(sfxBus)

@onready var music: HSlider = $Music
@export var musicBus : String = "Music"
var musicBusIndex : int = AudioServer.get_bus_index(musicBus)

func _ready() -> void:
	master.value = PlayerSettings.settings["Master Volume"]
	sfx.value = PlayerSettings.settings["SFX Volume"]
	music.value = PlayerSettings.settings["Music Volume"]

func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(masterBusIndex, linear_to_db(value))
	PlayerSettings.settings["Master Volume"] = value
	PlayerSettings._save()

func _on_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfxBusIndex, linear_to_db(value))
	PlayerSettings.settings["SFX Volume"] = value
	PlayerSettings._save()

func _on_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(musicBusIndex, linear_to_db(value))
	PlayerSettings.settings["Music Volume"] = value
	PlayerSettings._save()
