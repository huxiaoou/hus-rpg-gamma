extends Camera3D

class_name TestCamera

@export var speed: float = 6
@export var rotation_speed: float = PI / 6
@export var zoom_step: float = 0.15
@export var xlim: Vector2 = Vector2(8, 78)
@export var zlim: Vector2 = Vector2(8, 72)
@export var ylim: Vector2 = Vector2(2, 6)


func _process(delta: float) -> void:
    var rotation_direction: float = Input.get_axis("camera_rotate_counter_clockwise", "camera_rotate_clockwise")
    global_rotation.y += rotation_speed * delta * rotation_direction

    var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back").normalized()

    var velocity: Vector2 = direction.rotated(-global_rotation.y) * speed * delta
    var d: Vector3 = Vector3(velocity.x, 0, velocity.y)
    global_position += d

    global_position.x = clamp(global_position.x, xlim.x, xlim.y)
    global_position.z = clamp(global_position.z, zlim.x, zlim.y)
    global_position.y = clamp(global_position.y, ylim.x, ylim.y)


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("camera_up"):
        global_position += Vector3(0, zoom_step, 0)
    elif event.is_action_pressed("camera_down"):
        global_position -= Vector3(0, zoom_step, 0)
