extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_3d: Area3D = $Area3D

@export var spin_duration := 5.0

func _ready() -> void:
    animation_player.play("rotate", -1, 1/spin_duration, false)

func _on_area_3d_body_entered(body:Node3D) -> void:
    if not body in area_3d.get_overlapping_bodies():
        return
    else:
        GameEvents.coin_collected.emit()
        queue_free()

