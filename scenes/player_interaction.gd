extends Node3D

@onready var interaction_ray: RayCast3D = $InteractionRay
@onready var carrying_marker: Marker3D = $InteractionRay/CarryingMarker
@onready var texture_rect: TextureRect = $CenterContainer/TextureRect
@onready var color_rect: ColorRect = $CenterContainer/ColorRect

@export var pull_power: float = 10.0

var carry_icon := preload("res://textures/icon_carry.png")
var equip_icon := preload("res://textures/icon_equip.png")
var axe_icon := preload("res://textures/icon_axe.png")
var none_icon := preload("res://textures/icon_none.png")

var equipped: Array[String] = []
var carrying: Carryable = null

var equipable_to_icon_map = {
	"axe": axe_icon
}


func _physics_process(delta: float) -> void:
	if carrying:
		var a = carrying.global_transform.origin
		var b = carrying_marker.global_transform.origin
		carrying.set_linear_velocity((b - a) * pull_power)


func _input(event: InputEvent) -> void:
	var collider = interaction_ray.get_collider()
	update_crosshair(collider)
	
	if not Input.is_action_just_pressed("interact"):
		return
	
	if carrying:
		carrying.carried = false
		carrying = null
		return
	
	if collider is Equipable:
		equipped.append(collider.name)
		collider.queue_free()
	
	if collider is Interactable:
		collider.interact(equipped)
	
	if collider is Carryable:
		carrying = collider
		collider.carried = true


func update_crosshair(collider: Object) -> void:
	texture_rect.visible = false
	if carrying:
		return
	
	if collider is Equipable:
		texture_rect.visible = true
		texture_rect.texture = equip_icon
	elif collider is Carryable:
		texture_rect.visible = true
		texture_rect.texture = carry_icon
	elif collider is Interactable:
		texture_rect.visible = true
		if collider.interacts_with in equipped:
			texture_rect.texture = equipable_to_icon_map[collider.interacts_with]
		else:
			texture_rect.texture = none_icon
	
	if texture_rect.visible:
		color_rect.visible = false
	else:
		color_rect.visible = true
