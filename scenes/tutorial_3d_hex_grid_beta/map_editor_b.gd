extends Node

class_name MapEditorB

@onready var tiles: Node = $Tiles

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cursor: Cursor = $Cursor

var manger_mesh: Dictionary[String, HexTileB] = { }
var mgr_map_data: BiMap = BiMap.new()
var xz_plane_y: float = 0
var active_hex_coord: Vector2i = Vector2i.ZERO
var active_hex_tile: HexTileB = null

const HEXTILES_TEX_DIR = "res://scenes/tutorial_3d_hex_grid_beta/assets/hextiles/basic/"


class BiMap extends Resource:
    var forward: Dictionary[Vector2i, DataRecord] = { }


    func add_pair(key: Vector2i, value: DataRecord) -> void:
        forward[key] = value
        return


    func get_data_tile(coords: Vector2i) -> DataRecord:
        return forward[coords]


    func get_coords(data_tile: DataRecord) -> Vector2i:
        for key in forward.keys():
            if forward[key].is_equal(data_tile):
                return key
        return Vector2.INF


    func remove_pair_by_coords(coords: Vector2i) -> void:
        forward.erase(coords)
        return


func _ready() -> void:
    init_cursor()
    init_manager_mesh()
    test_generate(20)


func init_cursor() -> void:
    var active_point: Vector3 = ManagerHextileGrid.get_xz_projection()
    active_hex_coord = ManagerHextileGrid.point_to_hex_coordinates(active_point)
    cursor.update_pos_from_hex_coords(active_hex_coord)
    animation_player.play("cursor_idle")
    return


func init_manager_mesh() -> void:
    var dir: DirAccess = DirAccess.open(HEXTILES_TEX_DIR)
    if not dir:
        print("Failed to open directory: ", HEXTILES_TEX_DIR)
        return

    dir.list_dir_begin()
    for file: String in dir.get_files():
        if not file.ends_with(".png"):
            continue
        var tex: Texture2D = load(dir.get_current_dir() + "/" + file)
        for hex_type: String in DataHexTileB.get_hex_types():
            var data: DataHexTileB = DataHexTileB.new()
            data.multi_mesh_name = file.split(".")[0] + "_" + hex_type
            data.tex = tex
            data.hex_type = hex_type
            var hex_tile: HexTileB = HexTileB.new()
            hex_tile.data = data
            tiles.add_child(hex_tile)
            manger_mesh[data.multi_mesh_name] = hex_tile
            print("Loading texture: %s-%s" % [file, hex_type])
    return


func _process(_delta: float) -> void:
    var active_point: Vector3 = ManagerHextileGrid.get_xz_projection()
    if active_point == Vector3.INF:
        return
    var new_active_hex_coord: Vector2i = ManagerHextileGrid.point_to_hex_coordinates(active_point)
    if new_active_hex_coord != active_hex_coord:
        active_hex_coord = new_active_hex_coord
        cursor.update_pos_from_hex_coords(active_hex_coord)

    if active_hex_tile:
        active_point = ManagerHextileGrid.hex_coordinates_to_point(active_hex_coord, xz_plane_y)
        active_hex_tile.update_preview(active_point)
    return


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_accept"):
        if active_hex_tile:
            print("Hex tile already active: ", active_hex_tile.data.multi_mesh_name)
            print("Stopped preview of hex tile: ", active_hex_tile.data.multi_mesh_name)
            active_hex_tile.stop_preview()
            active_hex_tile = null
            return
        active_hex_tile = manger_mesh.values()[randi() % manger_mesh.values().size()]
        active_hex_tile.start_preview()
    elif event.is_action_pressed("confirm_hex_placement"):
        if (not active_hex_tile) or (not active_hex_tile.toggle_preview):
            print("No active hex tile to place!")
            return

        var pos: Vector3 = ManagerHextileGrid.get_xz_projection(xz_plane_y)
        var hex_coords: Vector2i = ManagerHextileGrid.point_to_hex_coordinates(pos)
        if hex_coords in mgr_map_data.forward:
            print("Hex already occupied at coords: ", hex_coords)
            return

        var hex_pos: Vector3 = ManagerHextileGrid.hex_coordinates_to_point(hex_coords, xz_plane_y)
        var data: DataRecord = active_hex_tile.add_instance_at(hex_pos)
        mgr_map_data.add_pair(hex_coords, data)

        # for next placement, start preview immediately
        active_hex_tile.start_preview()
    elif event.is_action_pressed("cancel_hex_placement"):
        if active_hex_tile:
            print("hex tile is active: ", active_hex_tile.data.multi_mesh_name)
            return

        var pos: Vector3 = ManagerHextileGrid.get_xz_projection(xz_plane_y)
        var hex_coords_to_remove: Vector2i = ManagerHextileGrid.point_to_hex_coordinates(pos)
        if hex_coords_to_remove not in mgr_map_data.forward:
            print("No hex to remove at coords: ", hex_coords_to_remove)
            return

        var data: DataRecord = mgr_map_data.get_data_tile(hex_coords_to_remove)
        var ht: HexTileB = manger_mesh[data.multi_mesh_name]
        var last_data: DataRecord = ht.remove_instance_from_index(data.id)
        var last_hex_coords: Vector2i = mgr_map_data.get_coords(last_data)
        mgr_map_data.add_pair(last_hex_coords, data)
        mgr_map_data.remove_pair_by_coords(hex_coords_to_remove)
    return


func test_generate(n: int = 100) -> void:
    for x: int in range(n):
        for z: int in range(n):
            var pos: Vector3 = ManagerHextileGrid.hex_coordinates_to_point(Vector2i(x, z), xz_plane_y)
            var hex_tile: HexTileB = manger_mesh.values()[randi() % manger_mesh.values().size()]
            var data: DataRecord = hex_tile.add_instance_at_without_preview(pos)
            mgr_map_data.add_pair(Vector2i(x, z), data)
