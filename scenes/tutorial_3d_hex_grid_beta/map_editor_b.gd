extends Node

class_name MapEditorB

@onready var hex_tile: HexTileB = $HexTile
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cursor: Cursor = $Cursor

var manger_mesh: Dictionary[String, HexTileB] = { }
var mgr_map_data: BiMap = BiMap.new()
var xz_plane_y: float = 0
var active_hex_coord: Vector2i = Vector2i.ZERO


class BiMap extends Resource:
    var forward: Dictionary[Vector2i, DataTileB] = { }


    func add_pair(key: Vector2i, value: DataTileB) -> void:
        forward[key] = value
        return


    func get_data_tile(coords: Vector2i) -> DataTileB:
        return forward[coords]


    func get_coords(data_tile: DataTileB) -> Vector2i:
        for key in forward.keys():
            if forward[key].is_equal(data_tile):
                return key
        return Vector2.INF


    func remove_pair_by_coords(coords: Vector2i) -> void:
        forward.erase(coords)
        return


func _ready() -> void:
    #test_generate(5)
    manger_mesh[hex_tile.multi_mesh_name] = hex_tile
    init_cursor()


func init_cursor() -> void:
    var active_point: Vector3 = ManagerHextileGrid.get_xz_projection()
    active_hex_coord = ManagerHextileGrid.point_to_hex_coordinates(active_point)
    cursor.update_pos_from_hex_coords(active_hex_coord)
    animation_player.play("cursor_idle")
    return


func _process(_delta: float) -> void:
    var active_point: Vector3 = ManagerHextileGrid.get_xz_projection()
    if active_point == Vector3.INF:
        return
    var new_active_hex_coord: Vector2i = ManagerHextileGrid.point_to_hex_coordinates(active_point)
    if new_active_hex_coord != active_hex_coord:
        active_hex_coord = new_active_hex_coord
        cursor.update_pos_from_hex_coords(active_hex_coord)
    return


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("confirm_hex_placement"):
        var pos: Vector3 = ManagerHextileGrid.get_xz_projection(xz_plane_y)
        var hex_coords: Vector2i = ManagerHextileGrid.point_to_hex_coordinates(pos)
        if hex_coords in mgr_map_data.forward:
            print("Hex already occupied at coords: ", hex_coords)
            return

        var hex_pos: Vector3 = ManagerHextileGrid.hex_coordinates_to_point(hex_coords, xz_plane_y)
        var data: DataTileB = hex_tile.add_instance_at(hex_pos)
        mgr_map_data.add_pair(hex_coords, data)
    elif event.is_action_pressed("cancel_hex_placement"):
        var pos: Vector3 = ManagerHextileGrid.get_xz_projection(xz_plane_y)
        var hex_coords_to_remove: Vector2i = ManagerHextileGrid.point_to_hex_coordinates(pos)
        if hex_coords_to_remove not in mgr_map_data.forward:
            print("No hex to remove at coords: ", hex_coords_to_remove)
            return

        var data: DataTileB = mgr_map_data.get_data_tile(hex_coords_to_remove)
        var ht: HexTileB = manger_mesh[data.multi_mesh_name]
        var last_data: DataTileB = ht.remove_instance_from_index(data.id)
        var last_hex_coords: Vector2i = mgr_map_data.get_coords(last_data)
        mgr_map_data.add_pair(last_hex_coords, data)
        mgr_map_data.remove_pair_by_coords(hex_coords_to_remove)
    return


func test_generate(n: int = 100) -> void:
    for x: int in range(n):
        for z: int in range(n):
            var pos: Vector3 = ManagerHextileGrid.hex_coordinates_to_point(Vector2i(x, z), xz_plane_y)
            hex_tile.add_instance_at(pos)
