extends MeshInstance3D

class_name HexTile

@export var data: DataHexTile


func _ready() -> void:
    mesh = data.get_mesh()
    if mesh == null:
        return
    # transform = transform.rotated(Vector3i(0, 1, 0), -2 * PI / 3)

    # --- update texture
    var mat = get_active_material(0).duplicate() # Duplicate so we don't change other instances
    mat.albedo_texture = data.tile_tex
    set_surface_override_material(0, mat)

    # --- update static_body
    var static_body: StaticBody3D = StaticBody3D.new()
    add_child(static_body)
    var collision_data: Array = data.get_item_shapes()
    for i: int in range(0, collision_data.size(), 2):
        var shape_res: Shape3D = collision_data[i] # The actual Shape (Box, Convex, etc.)
        var shape_transform: Transform3D = collision_data[i + 1] # The offset/rotation of that shape
        var collision_node = CollisionShape3D.new()
        collision_node.shape = shape_res
        collision_node.transform = shape_transform
        static_body.add_child(collision_node)

func init_from_data() -> void:
    _ready()
