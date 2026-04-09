extends Node3D

class_name MapGenerator

@export var scenes_array: Array[PackedScene] = [
    preload("res://scenes/tutorial_3d_hex_grid/hextiles/hextile_desert00.tscn"),
    preload("res://scenes/tutorial_3d_hex_grid/hextiles/hextile_desert01.tscn"),
    preload("res://scenes/tutorial_3d_hex_grid/hextiles/hextile_forest00.tscn"),
    preload("res://scenes/tutorial_3d_hex_grid/hextiles/hextile_forest01.tscn"),
    preload("res://scenes/tutorial_3d_hex_grid/hextiles/hextile_ocean00.tscn"),
    preload("res://scenes/tutorial_3d_hex_grid/hextiles/hextile_ocean01.tscn"),
    preload("res://scenes/tutorial_3d_hex_grid/hextiles/hextile_highland00.tscn"),
    preload("res://scenes/tutorial_3d_hex_grid/hextiles/hextile_highland01.tscn"),
    preload("res://scenes/tutorial_3d_hex_grid/hextiles/hextile_hills00.tscn"),
    preload("res://scenes/tutorial_3d_hex_grid/hextiles/hextile_hills01.tscn"),
    preload("res://scenes/tutorial_3d_hex_grid/hextiles/hextile_marsh00.tscn"),
    preload("res://scenes/tutorial_3d_hex_grid/hextiles/hextile_marsh01.tscn"),
    preload("res://scenes/tutorial_3d_hex_grid/hextiles/hextile_plains00.tscn"),
    preload("res://scenes/tutorial_3d_hex_grid/hextiles/hextile_plains01.tscn"),
    preload("res://scenes/tutorial_3d_hex_grid/hextiles/hextile_scrublands00.tscn"),
    preload("res://scenes/tutorial_3d_hex_grid/hextiles/hextile_scrublands01.tscn"),
]

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cursor: Sprite3D = $Cursor

var total: int = 10
var size: float = 0.5
var w: float = sqrt(3) * size # + 0.01
var h: float = 1.5 * size #- 0.01
var offset: float = 0.50 * w
var xz_plane_y: float = 0

var active_hex_coord: Vector2i = Vector2i.ZERO


func _ready() -> void:
    init_cursor()
    # generate_hex_test()


func init_cursor() -> void:
    var active_point: Vector3 = get_xz_projection()
    active_hex_coord = point_to_hex_coordinates(active_point)
    var active_hex_center: Vector3 = hex_coordinates_to_point(active_hex_coord)
    cursor.global_position = active_hex_center
    animation_player.play("cursor_idle")


func _process(_delta: float) -> void:
    var active_point: Vector3 = get_xz_projection()
    var new_active_hex_coord: Vector2i = point_to_hex_coordinates(active_point)
    if new_active_hex_coord != active_hex_coord:
        active_hex_coord = new_active_hex_coord
        var active_hex_center: Vector3 = hex_coordinates_to_point(active_hex_coord)
        cursor.global_position = active_hex_center


func get_xz_projection() -> Vector3:
    var camera: Camera3D = get_viewport().get_camera_3d()
    if camera == null:
        return Vector3.ZERO
    var mouse_pos: Vector2 = get_viewport().get_mouse_position()
    var ray_origin: Vector3 = camera.project_ray_origin(mouse_pos)
    var ray_direction: Vector3 = camera.project_ray_normal(mouse_pos)
    var plane: Plane = Plane(Vector3.UP, xz_plane_y)
    var intersection: Vector3 = plane.intersects_ray(ray_origin, ray_direction)
    return intersection


func point_to_hex_coordinates(point: Vector3) -> Vector2i:
    var r: int = roundi(point.z * h)
    var q: int = roundi((point.x - offset * int(r % 2 != 0)) / w)
    return Vector2i(q, r)


func hex_coordinates_to_point(hex_coords: Vector2i) -> Vector3:
    var x: float = hex_coords.x * w + offset * int(hex_coords.y % 2 != 0)
    var z: float = hex_coords.y * h
    return Vector3(x, xz_plane_y, z)


func add_hex_at_coord(hex_coords: Vector2i) -> void:
    # var scenes_array_size: int = scenes_array.size()
    # var id: int = randi_range(0, scenes_array_size - 1)
    var id: int = 0
    var hex: HexTile = scenes_array[id].instantiate()
    add_child(hex)
    hex.global_position = hex_coordinates_to_point(hex_coords)


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("confirm_hex_placement"):
        add_hex_at_coord(active_hex_coord)


func generate_hex_test() -> void:
    for x: int in total:
        for z: int in total:
            add_hex_at_coord(Vector2i(x, z))
