extends Node3D

@onready var spawned_items: Node3D = $SpawnedItems
@onready var label: Label = $Label

var tree_scene = preload("res://scenes/tree.tscn")
var foliage_scene = preload("res://scenes/foliage.tscn")
var clearing_scene = preload("res://scenes/clearing.tscn")
var player_scene = preload("res://scenes/player.tscn")
var coin_scene = preload("res://scenes/coin.tscn")

var tree_count := 100
var foliage_count := 500
var ground_size := 100.0
var placements := []
var coin_count := 5

var coins_collected := 0

func _ready() -> void:
	GameEvents.spawn.connect(_spawn)
	GameEvents.coin_collected.connect(_on_coin_collected)
	
	_init_placements()
	
	var clearing: Node3D = _random_spawn(clearing_scene, 5)
	var player: Node3D = _spawn(player_scene, Vector3.ZERO)

	clearing.look_at(player.position)

	_random_spawn_many(tree_scene, tree_count, 3)
	_random_spawn_many(foliage_scene, foliage_count, 1)
	_random_spawn_many(coin_scene, coin_count - 1, 1) 

func _spawn(scene: PackedScene, spawn_position: Vector3) -> Node:
	var instance = scene.instantiate()
	instance.position = spawn_position
	spawned_items.add_child(instance)
	return instance


func _on_coin_collected():
	coins_collected += 1
	label.text = "{coins_collected}/{coin_count}".format(
		{"coins_collected": coins_collected, "coin_count": coin_count}
	)
	label.show_then_fade()


func _init_placements() -> void:
	for i in range(ground_size):
		placements.append([])
		for j in range(ground_size):
			placements[i].append(0)


func _random_spawn_many(scene: PackedScene, count: int, size: int) -> void:
	for i in range(count):
		_random_spawn(scene, size)
		

func _random_spawn(scene: PackedScene, size: int) -> Node:
	var bound = ground_size / 2 - size
	var x = randi_range(-bound, bound)
	var z = randi_range(-bound, bound)
	
	while placements[x][z] == 1:
		x = randi_range(-bound, bound)
		z = randi_range(-bound, bound)
	
	_mark_placement(x, z, size)
	var spawned_instance = _spawn(scene, Vector3(x + size / 2, 0, z + size / 2))
	return spawned_instance


func _mark_placement(x: int, z: int, size: int) -> void:
	for i in range(size):
		for j in range(size):
			placements[x+i][z+j] = 1

