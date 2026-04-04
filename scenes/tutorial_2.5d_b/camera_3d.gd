extends Camera3D

class_name TestCamera

@export var speed: float = 6
@export var xlim: Vector2 = Vector2(8, 78)
@export var zlim: Vector2 = Vector2(8, 72)
@export var ylim: Vector2 = Vector2(2, 6)


func _process(delta: float) -> void:
    var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back").normalized()
    var velocity: Vector2 = direction * speed * delta
    var d: Vector3 = Vector3(velocity.x, 0, velocity.y)
    global_position += d

    if Input.is_action_pressed("camera_up"):
        global_position += Vector3(0, speed * delta, 0)
    elif Input.is_action_pressed("camera_down"):
        global_position -= Vector3(0, speed * delta, 0)
    global_position.x = clamp(global_position.x, xlim.x, xlim.y)
    global_position.z = clamp(global_position.z, zlim.x, zlim.y)
    global_position.y = clamp(global_position.y, ylim.x, ylim.y)
