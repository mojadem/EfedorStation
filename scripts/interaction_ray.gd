extends RayCast3D

var equipped: Array[String] = []

func _input(event: InputEvent) -> void:
	if not Input.is_action_just_pressed("interact"):
		return
	
	var collider = get_collider()
	if collider is Equipable:
		equipped.append(collider.name)
		collider.queue_free()
	
	if collider is Interactable:
		collider.interact(equipped)
	
