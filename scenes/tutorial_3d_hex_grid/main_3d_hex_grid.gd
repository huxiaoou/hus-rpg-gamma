extends Node3D

@onready var character_body_3d: CharacterBody3D = $CharacterBody3D
@onready var camera_world: CameraWorld = $CameraWorld

var lock_unit: bool = false
var is_ready: bool = false


func _process(_delta: float) -> void:
    if lock_unit and is_ready:
        camera_world.global_position = character_body_3d.global_position


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("camera_lock"):
        lock_unit = !lock_unit
        if lock_unit:
            is_ready = false
            var tw: Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
            tw.tween_property(camera_world, "global_position", character_body_3d.global_position, 0.5)
            await tw.finished
            is_ready = true
