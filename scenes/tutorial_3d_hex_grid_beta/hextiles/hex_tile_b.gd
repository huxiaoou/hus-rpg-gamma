extends MultiMeshInstance3D

class_name HexTileB

@export var data: DataHexTileB = null

var static_body: StaticBody3D = null


func _ready() -> void:
    if not data:
        print("HexTileB: No data assigned!")
        return

    if multimesh == null:
        multimesh = MultiMesh.new()
        multimesh.transform_format = MultiMesh.TRANSFORM_3D

    var lib_mesh: Mesh = data.get_mesh()
    if not lib_mesh:
        print("HexTileB: No mesh found in data!")
        return

    multimesh.mesh = lib_mesh.duplicate(true)
    multimesh.instance_count = data.max_count
    multimesh.visible_instance_count = 0

    var new_material: StandardMaterial3D = multimesh.mesh.surface_get_material(0)
    new_material.albedo_texture = data.tex
    # multimesh.mesh.surface_set_material(0, new_material)

    static_body = StaticBody3D.new()
    add_child(static_body)

    return


func add_instance_at(pos: Vector3) -> DataRecord:
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
    var new_data: DataRecord = DataRecord.new()
    new_data.multi_mesh_name = data.multi_mesh_name
    new_data.id = mesh_idx
    return new_data


func remove_instance_from_index(mesh_idx: int) -> DataRecord:
    var last_idx: int = multimesh.visible_instance_count - 1
    var last_xform: Transform3D = multimesh.get_instance_transform(last_idx)
    multimesh.set_instance_transform(mesh_idx, last_xform)
    multimesh.visible_instance_count -= 1

    static_body.get_child(mesh_idx).transform = static_body.get_child(last_idx).transform
    static_body.get_child(last_idx).queue_free()

    var data_to_remove: DataRecord = DataRecord.new()
    data_to_remove.multi_mesh_name = data.multi_mesh_name
    data_to_remove.id = last_idx
    return data_to_remove
