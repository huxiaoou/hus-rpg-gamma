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
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var astream_placement_confirm: AudioStream = preload("res://scenes/tutorial_3d_hex_grid/assets/Select A 001.wav")
var astream_placement_cancel: AudioStream = preload("res://scenes/tutorial_3d_hex_grid/assets/Signal Negative A 001.wav")
var astream_placement_notice: AudioStream = preload("res://scenes/tutorial_3d_hex_grid/assets/Notification B 001.wav")

var total: int = 10
var size: float = 0.5
var w: float = sqrt(3) * size # + 0.01
var h: float = 1.5 * size #- 0.01
var offset: float = 0.50 * w
var xz_plane_y: float = 0

var active_hex_coord: Vector2i = Vector2i.ZERO
@onready var map_data: DataMap = DataMap.new()


func _ready() -> void:
    init_cursor()
    # generate_hex_test()


func aplay_confirm() -> void:
    audio_stream_player.stream = astream_placement_confirm
    audio_stream_player.play()
    return


func aplay_cancel() -> void:
    audio_stream_player.stream = astream_placement_cancel
    audio_stream_player.play()
    return


func aplay_notice() -> void:
    audio_stream_player.stream = astream_placement_notice
    audio_stream_player.play()
    return


func init_cursor() -> void:
    var active_point: Vector3 = get_xz_projection()
    active_hex_coord = point_to_hex_coordinates(active_point)
    var active_hex_center: Vector3 = hex_coordinates_to_point(active_hex_coord)
    cursor.global_position = active_hex_center
    animation_player.play("cursor_idle")


func _process(_delta: float) -> void:
    var active_point: Vector3 = get_xz_projection()
    if active_point == Vector3.INF:
        return
    var new_active_hex_coord: Vector2i = point_to_hex_coordinates(active_point)
    if new_active_hex_coord != active_hex_coord:
        active_hex_coord = new_active_hex_coord
        var active_hex_center: Vector3 = hex_coordinates_to_point(active_hex_coord)
        cursor.global_position = active_hex_center


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


func add_hex_at_coord(hex_coords: Vector2i) -> void:
    if map_data.data.has(hex_coords):
        print("Cell %s already has cell placed" % hex_coords)
        aplay_notice()
        return

    var id: int = randi() % scenes_array.size()
    var hex: HexTile = scenes_array[id].instantiate()
    add_child(hex)
    hex.global_position = hex_coordinates_to_point(hex_coords)
    var data_map_cell: DataMap.DataMapCell = DataMap.DataMapCell.new()
    data_map_cell.cell_loc = hex_coords
    data_map_cell.hex_tile = hex
    map_data.data[hex_coords] = data_map_cell
    aplay_confirm()
    return


func remove_hex_at_coord(hex_coords: Vector2i) -> void:
    if not map_data.data.has(hex_coords):
        print("Cell %s has no cell placed" % hex_coords)
        aplay_notice()
        return

    var data_map_cell: DataMap.DataMapCell = map_data.data[hex_coords]
    var hex: HexTile = data_map_cell.hex_tile
    if hex != null:
        hex.queue_free()
    map_data.data.erase(hex_coords)
    aplay_cancel()
    print("Removed cell at %s" % hex_coords)
    return


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("confirm_hex_placement"):
        add_hex_at_coord(active_hex_coord)
    elif event.is_action_pressed("cancel_hex_placement"):
        remove_hex_at_coord(active_hex_coord)


func generate_hex_test() -> void:
    for x: int in total:
        for z: int in total:
            add_hex_at_coord(Vector2i(x, z))
