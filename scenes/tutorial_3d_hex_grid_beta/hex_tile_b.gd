extends MultiMeshInstance3D

class_name HexTileB

@export var multi_mesh_name: String = "hills01"
@export var hextileb_lib: MeshLibrary = preload("res://scenes/tutorial_3d_hex_grid_beta/meshlibs/hextiles.meshlib")
@export_enum("HexLow", "HexMid", "HexHigh") var hex_type = "HexMid"
@export var max_count: int = 10000
@export var tex: Texture2D = null

var static_body: StaticBody3D = null


func _ready() -> void:
    if not hextileb_lib:
        return

    var mesh_id: int = hextileb_lib.find_item_by_name(hex_type)
    if mesh_id == -1:
        return

    var lib_mesh: Mesh = hextileb_lib.get_item_mesh(mesh_id)
    if multimesh == null:
        multimesh = MultiMesh.new()
        multimesh.transform_format = MultiMesh.TRANSFORM_3D

    multimesh.mesh = lib_mesh
    multimesh.instance_count = max_count
    multimesh.visible_instance_count = 0

    var new_material: StandardMaterial3D = multimesh.mesh.surface_get_material(0).duplicate()
    new_material.albedo_texture = tex
    multimesh.mesh.surface_set_material(0, new_material)

    static_body = StaticBody3D.new()
    add_child(static_body)

    return


func add_instance_at(pos: Vector3) -> DataTileB:
    var mesh_idx: int = multimesh.visible_instance_count
    var xform: Transform3D = Transform3D(Basis(), pos)
    multimesh.set_instance_transform(mesh_idx, xform)

    var collision_node = CollisionShape3D.new()

    # method 2
    collision_node.shape = multimesh.mesh.create_trimesh_shape()
    collision_node.transform = xform
    collision_node.scale = xform.basis.get_scale()

    static_body.add_child(collision_node)

    multimesh.visible_instance_count += 1
    var data: DataTileB = DataTileB.new()
    data.multi_mesh_name = multi_mesh_name
    data.id = mesh_idx
    return data


func remove_instance_from_index(mesh_idx: int) -> DataTileB:
    var last_idx: int = multimesh.visible_instance_count - 1
    var last_xform: Transform3D = multimesh.get_instance_transform(last_idx)
    multimesh.set_instance_transform(mesh_idx, last_xform)
    multimesh.visible_instance_count -= 1

    static_body.get_child(mesh_idx).transform = static_body.get_child(last_idx).transform
    static_body.get_child(last_idx).queue_free()

    var data_to_remove: DataTileB = DataTileB.new()
    data_to_remove.multi_mesh_name = multi_mesh_name
    data_to_remove.id = last_idx
    return data_to_remove
