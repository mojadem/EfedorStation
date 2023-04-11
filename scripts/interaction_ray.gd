extends RayCast3D

@onready var carrying_marker: Node3D = $CarryingMarker

@export var pull_power: float = 10.0

var equipped: Array[String] = []
var carrying: Carryable = null


func _physics_process(delta: float) -> void:
	if carrying:
		var a = carrying.global_transform.origin
		var b = carrying_marker.global_transform.origin
		carrying.set_linear_velocity((b - a) * pull_power)


func _input(event: InputEvent) -> void:
	if not Input.is_action_just_pressed("interact"):
		return
	
	if carrying:
		carrying.carried = false
		carrying = null
		return
	
	var collider = get_collider()
	if collider is Equipable:
		equipped.append(collider.name)
		collider.queue_free()
	
	if collider is Interactable:
		collider.interact(equipped)
	
	if collider is Carryable:
		carrying = collider
		collider.carried = true
