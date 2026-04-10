extends Node3D

class_name CameraWorld

@export_category("Camera")

@export_group("Movement Speed")
@export var speed: float = 6
@export var rotation_speed: float = PI / 3
@export var zoom_step: float = 0.15

@export_group("Movement Boundry")
@export var xlim: Vector2 = Vector2(-20, 20)
@export var zlim: Vector2 = Vector2(-20, 20)
@export var ylim: Vector2 = Vector2(1, 3)

@onready var camera: Camera3D = $Camera


func _process(delta: float) -> void:
    # --- rotation ---
    var rotation_direction: float = Input.get_axis("camera_rotate_clockwise", "camera_rotate_counter_clockwise")
    rotate_y(rotation_speed * delta * rotation_direction)

    # --- movement ---
    var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back").normalized()
    var velocity: Vector2 = direction.rotated(-global_rotation.y) * speed * delta
    var d: Vector3 = Vector3(velocity.x, 0, velocity.y)
    global_position += d

    clamp_position()

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("camera_zoom_out"):
        global_position.y += zoom_step
    elif event.is_action_pressed("camera_zoom_in"):
        global_position.y -= zoom_step


func clamp_position() -> void:
    global_position.x = clamp(global_position.x, xlim.x, xlim.y)
    global_position.z = clamp(global_position.z, zlim.x, zlim.y)
    global_position.y = clamp(global_position.y, ylim.x, ylim.y)
    return
