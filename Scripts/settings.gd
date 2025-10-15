extends CanvasLayer
class_name Settings

@warning_ignore("unused_signal")
signal settings_closed

func _input(_event: InputEvent) -> void:
	if get_tree().get_node_count_in_group("Player") != 0:
		return
	if Input.is_action_just_pressed("exit"):
		_on_exit_settings_pressed()

func _open() -> void:
	self.show()
	get_tree().paused = true

func _on_exit_settings_pressed() -> void:
	self.hide()
	emit_signal("settings_closed")
