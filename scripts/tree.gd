extends Interactable

var log_scene = preload("res://scenes/log.tscn")
var stump_medium = preload("res://models/stump_medium.glb")
var stump_short = preload("res://models/stump_short.glb")
var stump_tall = preload("res://models/stump_tall.glb")
var stumps = [stump_short, stump_medium, stump_tall]


func interact():
	queue_free()
	GameEvents.spawn.emit(log_scene, self.position + Vector3.UP)
	stumps.shuffle()
	GameEvents.spawn.emit(stumps.front(), self.position)
