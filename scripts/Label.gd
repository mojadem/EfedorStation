extends Label

@onready var animation_player := $AnimationPlayer


func _ready() -> void:
    show()
    show_then_fade()


func show_then_fade():
    animation_player.stop()
    animation_player.play("show_then_fade")