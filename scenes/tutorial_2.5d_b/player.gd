extends CharacterBody3D

class_name Player

@export_range(0, 120, 0.1) var speed: float = 70
@export_range(0, 200, 0.1) var jump_speed: float = 12
@export_range(0, 12, 0.1) var gravity: = 40
@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D


func _process(delta: float) -> void:
    if is_on_floor():
        if Input.is_action_just_pressed("jump"):
            velocity.y = jump_speed
        var dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back").normalized()
        velocity.x = dir.x
        velocity.z = dir.y

        if velocity != Vector3.ZERO:
            if velocity.x < 0:
                animated_sprite_3d.flip_h = true
            elif velocity.x > 0:
                animated_sprite_3d.flip_h = false
            #if animated_sprite_3d.animation != "walk":
            animated_sprite_3d.play("walk")
        else:
            #if animated_sprite_3d.animation != "idle":
            animated_sprite_3d.play("idle")
    else:
        animated_sprite_3d.play("idle")
        velocity += gravity * Vector3.DOWN * delta
    move_and_slide()
