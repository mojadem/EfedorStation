extends Node3D

@onready var spawned_items: Node3D = $SpawnedItems

func _ready() -> void:
	GameEvents.spawn.connect(_on_spawn)

func _on_spawn(scene: PackedScene, position):
	var instance = scene.instantiate()
	instance.position = position
	spawned_items.add_child(instance)
