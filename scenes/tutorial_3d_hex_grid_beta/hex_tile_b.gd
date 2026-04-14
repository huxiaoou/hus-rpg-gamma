extends MultiMeshInstance3D

class_name HexTileB

@export var hextileb_lib: MeshLibrary = preload("res://scenes/tutorial_3d_hex_grid_beta/meshlibs/hextiles.meshlib")
@export_enum("HexLow", "HexMid", "HexHigh") var hex_type = "HexMid"
@export var max_count: int = 10000
@export var tex: Texture2D = null

var static_body: StaticBody3D = null

var xz_plane_y: float = 0
var size: float = 0.5
var w: float = sqrt(3) * size # + 0.01
var h: float = 1.5 * size #- 0.01
var offset: float = 0.50 * w


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
    
    test_generate(5)
    return


func add_instance_at(pos: Vector3) -> void:
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
    return


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("confirm_hex_placement"):
        var pos: Vector3 = get_xz_projection()
        add_instance_at(pos)


func get_xz_projection() -> Vector3:
    var camera: Camera3D = get_viewport().get_camera_3d()
    if camera == null:
        return Vector3.INF
    var mouse_pos: Vector2 = get_viewport().get_mouse_position()
    var ray_origin: Vector3 = camera.project_ray_origin(mouse_pos)
    var ray_direction: Vector3 = camera.project_ray_normal(mouse_pos)
    var plane: Plane = Plane(Vector3.UP, xz_plane_y)
    var intersection: Variant = plane.intersects_ray(ray_origin, ray_direction)
    if intersection == null:
        return Vector3.INF
    return intersection


func test_generate(n: int = 100) -> void:
    for x: int in range(n):
        for z: int in range(n):
            var pos: Vector3 = Vector3(x * w + offset * int(z % 2 != 0), 0, z * h)
            add_instance_at(pos)
