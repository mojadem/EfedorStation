extends RayCast3D

func _input(event: InputEvent) -> void:
	var collider = get_collider()
	if collider:
		print(collider.get_parent().name)
