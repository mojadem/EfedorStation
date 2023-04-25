extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var burn_duration: float = 90.0

var log_in_area: Log = null


func _ready() -> void:
	animation_player.play("burning", -1, 1/burn_duration, false)


func _physics_process(delta: float) -> void:
	if log_in_area and not log_in_area.carried:
		ignite_fire(log_in_area)
		log_in_area = null


func _on_ignition_area_body_entered(body: Node3D) -> void:
	if body is Log:
		log_in_area = body


func ignite_fire(log: Log) -> void:
	animation_player.stop()
	animation_player.play("burning", -1, 1/burn_duration, false)
	log.queue_free()
