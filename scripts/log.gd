extends Carryable

class_name Log

@onready var area_3d: Area3D = $Area3D

var campfire_scene = preload("res://scenes/campfire.tscn")
var log_count := 0


func _physics_process(_delta: float) -> void:
	var nearby_logs: Array[Node3D] = area_3d \
		.get_overlapping_bodies() \
		.filter(func(body: Node3D): return body is Log) \
		.filter(func(l: Log): return not l.carried)
	
	if nearby_logs.size() < 5:
		return
	
	var sorted_logs: Array[StringName] = []
	for l in nearby_logs:
		sorted_logs.append(l.name)
	sorted_logs.sort_custom(func(a, b): return a.casecmp_to(b) < 0)
	
	if self.name == sorted_logs.front():
		_spawn_campfire(nearby_logs)


func _spawn_campfire(nearby_logs: Array[Node3D]) -> void:
	await get_tree().create_timer(0.5).timeout
	
	for l in nearby_logs:
		l.queue_free()
	
	GameEvents.spawn.emit(campfire_scene, self.position)
