extends MeshInstance3D

class_name HexTile

@export var tile_tex: Texture2D = null
@export var meshlib: MeshLibrary = preload("res://scenes/tutorial_3d_hex_grid/meshlibs/hexagon_tiles_with_border.meshlib")
@export_enum("HexLow", "HexMid", "HexHigh") var mesh_name: String = "HexMid"


func _ready() -> void:
    var id: int = meshlib.find_item_by_name(mesh_name)
    if id == -1:
        print("Tile with name %s is not found in meshlib" % mesh_name)
        return
    mesh = meshlib.get_item_mesh(id)
    # transform = transform.rotated(Vector3i(0, 1, 0), -2 * PI / 3)

    # --- update texture
    var mat = get_active_material(0).duplicate() # Duplicate so we don't change other instances
    mat.albedo_texture = tile_tex
    set_surface_override_material(0, mat)

    # --- update static_body
    var static_body: StaticBody3D = StaticBody3D.new()
    add_child(static_body)
    var collision_data = meshlib.get_item_shapes(id)
    for i: int in range(0, collision_data.size(), 2):
        var shape_res: Shape3D = collision_data[i] # The actual Shape (Box, Convex, etc.)
        var shape_transform: Transform3D = collision_data[i + 1] # The offset/rotation of that shape
        var collision_node = CollisionShape3D.new()
        collision_node.shape = shape_res
        collision_node.transform = shape_transform
        static_body.add_child(collision_node)
