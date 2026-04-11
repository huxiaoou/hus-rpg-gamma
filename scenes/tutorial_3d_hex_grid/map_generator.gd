extends Node3D

class_name MapGenerator

@export var scenes_database: Dictionary[String, PackedScene] = {
    "desert00": preload("res://scenes/tutorial_3d_hex_grid/hextiles/hextile_desert00.tscn"),
    "desert01": preload("res://scenes/tutorial_3d_hex_grid/hextiles/hextile_desert01.tscn"),
    "forest00": preload("res://scenes/tutorial_3d_hex_grid/hextiles/hextile_forest00.tscn"),
    "forest01": preload("res://scenes/tutorial_3d_hex_grid/hextiles/hextile_forest01.tscn"),
    "ocean00": preload("res://scenes/tutorial_3d_hex_grid/hextiles/hextile_ocean00.tscn"),
    "ocean01": preload("res://scenes/tutorial_3d_hex_grid/hextiles/hextile_ocean01.tscn"),
    "highland00": preload("res://scenes/tutorial_3d_hex_grid/hextiles/hextile_highland00.tscn"),
    "highland01": preload("res://scenes/tutorial_3d_hex_grid/hextiles/hextile_highland01.tscn"),
    "hills00": preload("res://scenes/tutorial_3d_hex_grid/hextiles/hextile_hills00.tscn"),
    "hills01": preload("res://scenes/tutorial_3d_hex_grid/hextiles/hextile_hills01.tscn"),
    "marsh00": preload("res://scenes/tutorial_3d_hex_grid/hextiles/hextile_marsh00.tscn"),
    "marsh01": preload("res://scenes/tutorial_3d_hex_grid/hextiles/hextile_marsh01.tscn"),
    "plains00": preload("res://scenes/tutorial_3d_hex_grid/hextiles/hextile_plains00.tscn"),
    "plains01": preload("res://scenes/tutorial_3d_hex_grid/hextiles/hextile_plains01.tscn"),
    "scrublands00": preload("res://scenes/tutorial_3d_hex_grid/hextiles/hextile_scrublands00.tscn"),
    "scrublands01": preload("res://scenes/tutorial_3d_hex_grid/hextiles/hextile_scrublands01.tscn"),
}

const SAVE_PATH = "user://map.tres"

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
@onready var manager_cells: Dictionary[Vector2i, HexTile] = { }
@onready var map_data: DataMap = DataMap.new()

@onready var tiles_selector: TilesSelector = $UI/TilesSelector

func _ready() -> void:
    init_cursor()
    load_map()
    tiles_selector.setup(scenes_database)
    # generate_hex_test()


func save_map() -> void:
    var error: int = ResourceSaver.save(map_data, SAVE_PATH)
    if error != OK:
        print("Error saving map: %s" % error)
        aplay_notice()
        return
    print("Map saved successfully.")
    aplay_confirm()
    return


func load_map() -> void:
    if not ResourceLoader.exists(SAVE_PATH):
        print("Error loading map: No resource found at %s" % SAVE_PATH)
        aplay_notice()
        return
    var loaded_resource: Resource = ResourceLoader.load(SAVE_PATH, "DataMap")
    if loaded_resource == null:
        print("Error loading map: Resource not found at %s" % SAVE_PATH)
        aplay_notice()
        return
    if not loaded_resource is DataMap:
        print("Error loading map: Resource at %s is not of type DataMap" % SAVE_PATH)
        aplay_notice()
        return
    map_data = loaded_resource as DataMap
    for cell: Vector2i in map_data.data:
        add_hex_at_coord(cell, map_data.data[cell].tile_name)
    print("Map loaded successfully.")
    aplay_confirm()
    return


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


func add_hex_at_coord(hex_coords: Vector2i, tile_name: String) -> void:
    if manager_cells.has(hex_coords):
        print("Cell %s already has cell placed" % hex_coords)
        aplay_notice()
        return
    var scene: PackedScene = scenes_database.get(tile_name, null)
    if scene == null:
        print("Error: No scene found for tile name %s" % tile_name)
        aplay_notice()
        return

    var hex: HexTile = scene.instantiate()
    add_child(hex)
    hex.global_position = hex_coordinates_to_point(hex_coords)
    var data_map_cell: DataMapCell = DataMapCell.new()
    data_map_cell.tile_name = hex.data.tile_name
    map_data.data[hex_coords] = data_map_cell
    manager_cells[hex_coords] = hex
    print("Added cell at %s" % hex_coords)
    aplay_confirm()
    return


func remove_hex_at_coord(hex_coords: Vector2i) -> void:
    if not manager_cells.has(hex_coords):
        print("Cell %s has no cell placed" % hex_coords)
        aplay_notice()
        return
    var hex: HexTile = manager_cells[hex_coords]
    if hex != null:
        hex.queue_free()
    manager_cells.erase(hex_coords)
    map_data.data.erase(hex_coords)
    aplay_cancel()
    print("Removed cell at %s" % hex_coords)
    return


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("confirm_hex_placement"):
        var tile_name: String = scenes_database.keys()[randi() % scenes_database.size()] # Random tile for testing
        add_hex_at_coord(active_hex_coord, tile_name)
    elif event.is_action_pressed("cancel_hex_placement"):
        remove_hex_at_coord(active_hex_coord)
    elif event.is_action_pressed("save_game"):
        save_map()
    return
