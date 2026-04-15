extends Node

class_name MapEditorB

@onready var hex_tile: HexTileB = $HexTile

var map_data: Dictionary[Vector2i, DataTileB] = { }
var manger_mesh: Dictionary[String, HexTileB] = { }

var xz_plane_y: float = 0
var size: float = 0.5
var w: float = sqrt(3) * size # + 0.01
var h: float = 1.5 * size #- 0.01
var offset: float = 0.50 * w


func _ready() -> void:
    #test_generate(5)
    manger_mesh[hex_tile.multi_mesh_name] = hex_tile


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("confirm_hex_placement"):
        var pos: Vector3 = get_xz_projection()
        var hex_coords: Vector2i = point_to_hex_coordinates(pos)
        var hex_pos: Vector3 = hex_coordinates_to_point(hex_coords)
        var mesh_idx: int = hex_tile.add_instance_at(hex_pos, hex_coords)
        var data: DataTileB = DataTileB.new()
        data.multi_mesh_name = hex_tile.multi_mesh_name
        data.id = mesh_idx
        map_data[hex_coords] = data
    elif event.is_action_pressed("cancel_hex_placement"):
        var pos: Vector3 = get_xz_projection()
        var hex_coords: Vector2i = point_to_hex_coordinates(pos)
        var data: DataTileB = map_data[hex_coords]
        var ht: HexTileB = manger_mesh[data.multi_mesh_name]
        var new_hex_coords: Vector2i = ht.remove_instance_from_index(data.id)
        map_data[new_hex_coords] = data
        map_data.erase(hex_coords)
    return


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


func point_to_hex_coordinates(point: Vector3) -> Vector2i:
    var r: int = roundi(point.z / h)
    var q: int = roundi((point.x - offset * int(r % 2 != 0)) / w)
    return Vector2i(q, r)


func hex_coordinates_to_point(hex_coords: Vector2i) -> Vector3:
    var x: float = hex_coords.x * w + offset * int(hex_coords.y % 2 != 0)
    var z: float = hex_coords.y * h
    return Vector3(x, xz_plane_y, z)


func test_generate(n: int = 100) -> void:
    for x: int in range(n):
        for z: int in range(n):
            var pos: Vector3 = Vector3(x * w + offset * int(z % 2 != 0), 0, z * h)
            hex_tile.add_instance_at(pos, Vector2i(x, z))
