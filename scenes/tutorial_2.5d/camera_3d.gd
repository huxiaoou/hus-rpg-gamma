extends Camera3D

@export var speed: float = 10.0
@export var acceleration: float = 5.0

# Optional: Set boundaries so the "audience" doesn't fly off into the void
@export var limit_x: Vector2 = Vector2(-20, 20)
@export var limit_z: Vector2 = Vector2(0, 15)

func _process(delta):
    # 1. Get the input vector from WASD
    var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
    
    # 2. Map 2D input (x, y) to 3D movement (x, z)
    # We use 'input_dir.y' for the Z axis movement
    var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
    
    # 3. Calculate target velocity
    var target_velocity = direction * speed
    
    # 4. Smoothly move the camera's position
    # We only change X and Z, keeping Y (height) constant
    global_position.x = lerp(global_position.x, global_position.x + target_velocity.x, acceleration * delta)
    global_position.z = lerp(global_position.z, global_position.z + target_velocity.z, acceleration * delta)

    # 5. Apply stage boundaries (clamping)
    global_position.x = clamp(global_position.x, limit_x.x, limit_x.y)
    global_position.z = clamp(global_position.z, limit_z.x, limit_z.y)
