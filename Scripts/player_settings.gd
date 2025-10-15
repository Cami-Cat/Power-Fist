extends Node

@onready var Levels = {"Levels Complete": [],
			  "Level Time": [],
			  "Level Score": [],
			  "Score Medals": [],
			  "Time Medals": [],
			  "Total Medals": [] 
			}

@onready var settings = {"Master Volume": 0.5,
						"SFX Volume": 0.5,
						"Music Volume": 0.5,
						"Fullscreen": true,
						"Vsync": true
					}

enum medal {NONE, BRONZE, SILVER, GOLD, PLATINUM}

var scoreMedal = medal.BRONZE
var timeMedal = medal.BRONZE
var totalMedal = medal.BRONZE
var configFile

var savePath := "user://save.ini"

func _ready() -> void:
	_load()

func _completed_level(level : Level, time : int, score : int) -> void:
	var index : int
	
	scoreMedal = _calculate_level_score(level, score)
	timeMedal = _calculate_level_time(level, time)
	totalMedal = timeMedal

	if !Levels["Levels Complete"].has(level.levelID):
		Levels["Levels Complete"].append(level.levelID)
		Levels["Level Time"].append(time)
		Levels["Level Score"].append(score)
		Levels["Score Medals"].append(scoreMedal)
		Levels["Time Medals"].append(timeMedal)
		Levels["Total Medals"].append(totalMedal)
	else:
		index = Levels["Levels Complete"].find(level.levelID)
		if Levels["Level Time"][index] > time:
			Levels["Level Time"][index] = time
		if Levels["Level Score"][index] < score:
			Levels["Level Score"][index] = score
		Levels["Score Medals"][index] = scoreMedal
		Levels["Time Medals"][index] = timeMedal
		Levels["Total Medals"][index] = totalMedal

	_save()

func _calculate_level_score(level : Level, score : int) -> medal:
	if score >= level.medalScoreRequirements["Platinum Score"]:
		return medal.PLATINUM
	elif score >= level.medalScoreRequirements["Gold Score"]:
		return medal.GOLD
	elif score >= level.medalScoreRequirements["Silver Score"]:
		return medal.SILVER
	elif score >= level.medalScoreRequirements["Bronze Score"]:
		return medal.BRONZE
	else:
		return medal.NONE

func _calculate_level_time(level : Level, time : int) -> medal:
	if time >= level.medalTimeRequirements["Platinum Time"]:
		return medal.PLATINUM
	elif time >= level.medalTimeRequirements["Gold Time"]:
		return medal.GOLD
	elif time >= level.medalTimeRequirements["Silver Time"]:
		return medal.SILVER
	elif time >= level.medalTimeRequirements["Bronze Time"]:
		return medal.BRONZE
	else:
		return medal.NONE
	
func _load() -> void:
	configFile = ConfigFile.new()
	var error = configFile.load(savePath)
	if error:
		print("DEBUG >> No file found, loading with nothing")
		_initial_load()
		return
	
	Levels = configFile.get_value("Levels", "Dict")
	settings = configFile.get_value("Settings", "User Settings")

func _initial_load() -> void:
	settings["Master Volume"] = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	settings["SFX Volume"] = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	settings["Music Volume"] = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))

func _save() -> void:
	configFile = ConfigFile.new()
	_save_levels()
	_save_settings()

func _save_levels() -> void:
	
	configFile.set_value("Levels", "Dict", Levels)
	
func _save_settings() -> void:
	
	configFile.set_value("Settings", "User Settings", settings)
	
	var error = configFile.save(savePath)
	if error:
		print("ERROR >> An error occurred while saving setings: %02d" % [error])
