extends Panel
class_name Toggles

@onready var fullscreen: CheckButton = $"Control List/Movement/Fullscreen"
@onready var vsync: CheckButton = $"Control List/Movement/Vsync"

func _ready() -> void:
	if PlayerSettings.settings.get("Fullscreen") == true: fullscreen.button_pressed = true
	else: fullscreen.button_pressed = false
	if PlayerSettings.settings.get("Vsync") == true: vsync.button_pressed = true
	else: vsync.button_pressed = false

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		PlayerSettings.settings["Fullscreen"] = true
		PlayerSettings._save()
		return
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	PlayerSettings.settings["Fullscreen"] = false
	PlayerSettings._save()

func _on_vsync_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSyncMode.VSYNC_ENABLED)
		PlayerSettings.settings["Vsync"] = true
		PlayerSettings._save()
		return
	DisplayServer.window_set_vsync_mode(DisplayServer.VSyncMode.VSYNC_DISABLED)
	PlayerSettings.settings["Vsync"] = false
	PlayerSettings._save()
