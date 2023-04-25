extends Carryable

class_name Log

@onready var area_3d: Area3D = $Area3D

var campfire_scene = preload("res://scenes/campfire.tscn")
var log_count: int = 0


func _ready() -> void:
	print(self.name)


func _physics_process(delta: float) -> void:
	var nearby_logs: Array[Node3D] = area_3d \
		.get_overlapping_bodies() \
		.filter(func(body: Node3D): return body is Log) \
		.filter(func(log: Log): return not log.carried)
	
	if nearby_logs.size() < 5:
		return
	
	var sorted_logs: Array[StringName]
	for log in nearby_logs:
		sorted_logs.append(log.name)
	sorted_logs.sort_custom(func(a, b): return a.casecmp_to(b) < 0)
	
	if self.name == sorted_logs.front():
		_spawn_campfire(nearby_logs)


func _spawn_campfire(nearby_logs: Array[Node3D]) -> void:
	await get_tree().create_timer(0.5).timeout
	
	for log in nearby_logs:
		log.queue_free()
	
	GameEvents.spawn.emit(campfire_scene, self.position)
