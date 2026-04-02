extends Camera3D

class_name TestCamera

var speed: float = 8

func _process(delta: float) -> void:
    var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back").normalized()
    var velocity: Vector2 = direction * speed * delta
    var d: Vector3 = Vector3(velocity.x, 0, velocity.y)
    global_position += d
    
    if Input.is_action_pressed("camera_up"):
        global_position += Vector3(0, speed * delta, 0)
    elif Input.is_action_pressed("camera_down"):
        global_position -= Vector3(0, speed * delta, 0)
    global_position.y = clamp(global_position.y, 2, 8)
