extends Area3D

func _kill():
	get_parent()._kill()
