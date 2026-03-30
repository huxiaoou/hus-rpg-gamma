extends CharacterBody3D

class_name Unit

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
    animation_player.play("idle")
    
