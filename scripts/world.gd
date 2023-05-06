extends Node3D

@onready var spawned_items: Node3D = $SpawnedItems
@onready var coin_label: Label = $CoinLabel
@onready var tree_label: Label = $TreeLabel
@onready var win_label: Label = $WinLabel

var tree_scene = preload("res://scenes/tree.tscn")
var foliage_scene = preload("res://scenes/foliage.tscn")
var clearing_scene = preload("res://scenes/clearing.tscn")
var player_scene = preload("res://scenes/player.tscn")
var coin_scene = preload("res://scenes/coin.tscn")

var placements := []
var ground_size := 50.0
var foliage_count := 500

var tree_count := 100
var trees_cut := 0

var coin_count := 5
var coins_collected := 0

func _ready() -> void:
	GameEvents.spawn.connect(_spawn)
	GameEvents.coin_collected.connect(_on_coin_collected)
	GameEvents.tree_cut.connect(_on_tree_cut)
	
	_init_placements()
	
	var clearing: Node3D = _random_spawn(clearing_scene, 5)
	var player: Node3D = _spawn(player_scene, Vector3.ZERO)

	clearing.look_at(player.position)

	_random_spawn_many(tree_scene, tree_count, 3)
	_random_spawn_many(foliage_scene, foliage_count, 1)
	_random_spawn_many(coin_scene, coin_count - 1, 1) 


func _physics_process(_delta: float) -> void:
	if coins_collected == coin_count and trees_cut == tree_count:
		win_label.show()


func _spawn(scene: PackedScene, spawn_position: Vector3) -> Node:
	var instance = scene.instantiate()
	instance.position = spawn_position
	spawned_items.add_child(instance)

	if instance is Log:
		instance.apply_central_impulse(Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)) * 3)

	return instance


func _on_coin_collected():
	coins_collected += 1

	if coins_collected == 6:
		return

	coin_label.text = "{coins_collected}/{coin_count}".format(
		{"coins_collected": coins_collected, "coin_count": coin_count}
	)
	coin_label.show_then_fade()


func _on_tree_cut():
	if trees_cut + 1 == tree_count:
		_random_spawn(coin_scene, 1)
		coin_count += 1
		coin_label.show_then_fade()
	
	trees_cut += 1
	tree_label.text = "{trees_cut}/{tree_count}".format(
		{"trees_cut": trees_cut, "tree_count": tree_count}
	)
	tree_label.show_then_fade()
	


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

