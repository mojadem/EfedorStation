extends Interactable

var log_scene = preload("res://scenes/log.tscn")

func interact(equipped):
	if "axe" in equipped:
		GameEvents.spawn.emit(log_scene, self.position)
		queue_free()
