extends Node

class_name MapEditorB

@onready var tiles: Node = $Tiles

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cursor: Cursor = $Cursor
@onready var ui_buttons_hextile_b: UIButtonsHextileB = $UI/UIButtonsHextileB
@onready var ui_menu_legend: UIMenuLegend = $UI/UIMenuLegend
@onready var as_player: EditorAudioStreamPlayer = $ASPlayer

var manger_mesh: Dictionary[String, HexTileB] = { }
var mgr_map_data: BiMap = BiMap.new()
var xz_plane_y: float = 0
var active_hex_coord: Vector2i = Vector2i.ZERO
var active_hex_tile: HexTileB = null
var active_hex_btn: ButtonHextileB = null

const HEXTILES_TEX_DIR = "res://scenes/tutorial_3d_hex_grid_beta/assets/hextiles/basic/"
const SAVE_PATH = "user://mapb.tres"


func _ready() -> void:
    init_cursor()
    init_manager_mesh()
    init_ui()
    load_map()
    ui_menu_legend.setup(manger_mesh)
    print("MapEditorB ready with %d hex tiles in manager." % manger_mesh.size())


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


func init_ui() -> void:
    var i: int = 0
    var keys: Array[String] = manger_mesh.keys()
    for btn: ButtonHextileB in ui_buttons_hextile_b.get_buttons():
        btn.btn_hextile_activated.connect(on_btn_activated)
        btn.btn_hextile_deactivated.connect(on_btn_deactivated)
        while i < keys.size():
            var key: String = keys[i]
            if not key.ends_with("HexMid"):
                i += 1
                continue

            var hextile: HexTileB = manger_mesh[keys[i]]
            if not hextile.data.hex_name.ends_with("00"):
                i += 1
                continue

            var data: DataBtnHextile = DataBtnHextile.new()
            data.icon = hextile.data.tex
            data.hex_name = hextile.data.hex_name
            data.hex_type = hextile.data.get_hex_type_enum()
            btn.setup(data)
            i += 1
            print("Button setup with hex tile: %s" % key)
            break
    return


func _process(_delta: float) -> void:
    var active_point: Vector3 = ManagerHextileGrid.get_xz_projection()
    if active_point == Vector3.INF:
        return
    var new_active_hex_coord: Vector2i = ManagerHextileGrid.point_to_hex_coordinates(active_point)
    if new_active_hex_coord != active_hex_coord:
        active_hex_coord = new_active_hex_coord
        cursor.update_pos_from_hex_coords(active_hex_coord)
        as_player.play_hex_changed()

    if active_hex_tile:
        active_point = ManagerHextileGrid.hex_coordinates_to_point(active_hex_coord, xz_plane_y)
        active_hex_tile.update_preview(active_point)
    return


func on_btn_activated(multi_mesh_name: String, btn: ButtonHextileB) -> void:
    as_player.play_btn_pressed()
    if active_hex_btn and active_hex_btn != btn:
        active_hex_btn.deactivete()
        active_hex_tile.stop_preview()

    active_hex_tile = manger_mesh.get(multi_mesh_name)
    if not active_hex_tile:
        print("Failed to find hex tile for multi_mesh_name: ", multi_mesh_name)
        return
    active_hex_tile.start_preview()
    active_hex_btn = btn
    return


func on_btn_deactivated(_multi_mesh_name: String, btn: ButtonHextileB) -> void:
    as_player.play_cancel()
    if active_hex_btn and active_hex_btn == btn:
        active_hex_tile.stop_preview()
        active_hex_tile = null
        active_hex_btn = null
    return


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("confirm_hex_placement"):
        if (not active_hex_tile) or (not active_hex_tile.toggle_preview):
            as_player.play_warning()
            print("No active hex tile to place!")
            return

        var pos: Vector3 = ManagerHextileGrid.get_xz_projection(xz_plane_y)
        var hex_coords: Vector2i = ManagerHextileGrid.point_to_hex_coordinates(pos)
        if hex_coords in mgr_map_data.forward:
            as_player.play_warning()
            print("Hex already occupied at coords: ", hex_coords)
            return
        as_player.play_confirm()

        active_hex_tile.stop_preview()
        var hex_pos: Vector3 = ManagerHextileGrid.hex_coordinates_to_point(hex_coords, xz_plane_y)
        var data: DataRecord = active_hex_tile.add_instance_at(hex_pos)
        mgr_map_data.add_pair(hex_coords, data)

        # for next placement, start preview immediately
        active_hex_tile.start_preview()
    elif event.is_action_pressed("cancel_hex_placement"):
        if active_hex_tile:
            as_player.play_warning()
            print("hex tile is active: ", active_hex_tile.data.multi_mesh_name)
            return

        var pos: Vector3 = ManagerHextileGrid.get_xz_projection(xz_plane_y)
        var hex_coords_to_remove: Vector2i = ManagerHextileGrid.point_to_hex_coordinates(pos)
        if hex_coords_to_remove not in mgr_map_data.forward:
            as_player.play_warning()
            print("No hex to remove at coords: ", hex_coords_to_remove)
            return

        as_player.play_confirm()
        var data: DataRecord = mgr_map_data.get_data_tile(hex_coords_to_remove)
        var ht: HexTileB = manger_mesh[data.multi_mesh_name]
        var last_data: DataRecord = ht.remove_instance_from_index(data.id)
        var last_hex_coords: Vector2i = mgr_map_data.get_coords(last_data)
        mgr_map_data.add_pair(last_hex_coords, data)
        mgr_map_data.remove_pair_by_coords(hex_coords_to_remove)
    elif event.is_action_pressed("cancel_hex_selection"):
        if active_hex_btn:
            active_hex_btn.deactivete()
            active_hex_tile.stop_preview()
            active_hex_tile = null
            active_hex_btn = null
            as_player.play_cancel()
    elif event.is_action_pressed("debug_test_increase"):
        if active_hex_btn:
            if active_hex_btn.increase_hex_type():
                as_player.play_btn_pressed()
                active_hex_tile.stop_preview()
                active_hex_tile = manger_mesh[active_hex_btn.multi_mesh_name]
                active_hex_tile.start_preview()
                return
        as_player.play_warning()
        print("Failed to increase hex type beyond max for button")
    elif event.is_action_pressed("debug_test_decrease"):
        if active_hex_btn:
            if active_hex_btn.decrease_hex_type():
                as_player.play_btn_pressed()
                active_hex_tile.stop_preview()
                active_hex_tile = manger_mesh[active_hex_btn.multi_mesh_name]
                active_hex_tile.start_preview()
                return
        as_player.play_warning()
        print("Failed to decrease hex type beyond min for button")
    elif event.is_action_pressed("save_game"):
        save_map()
    return


func test_generate(n: int = 100) -> void:
    for x: int in range(n):
        for z: int in range(n):
            var pos: Vector3 = ManagerHextileGrid.hex_coordinates_to_point(Vector2i(x, z), xz_plane_y)
            var hex_tile: HexTileB = manger_mesh.values()[randi() % manger_mesh.values().size()]
            var data: DataRecord = hex_tile.add_instance_at(pos)
            mgr_map_data.add_pair(Vector2i(x, z), data)


func save_map() -> void:
    var error: int = ResourceSaver.save(mgr_map_data, SAVE_PATH)
    if error != OK:
        print("Error saving map: %s" % error)
        as_player.play_warning()
        return
    print("Map saved successfully.")
    as_player.play_confirm()
    return


func load_map() -> void:
    if not ResourceLoader.exists(SAVE_PATH):
        print("Error loading map: No resource found at %s" % SAVE_PATH)
        as_player.play_warning()
        return
    var loaded_resource: Resource = ResourceLoader.load(SAVE_PATH, "BiMap")
    if loaded_resource == null:
        print("Error loading map: Resource not found at %s" % SAVE_PATH)
        as_player.play_warning()
        return
    if loaded_resource is not BiMap:
        print("Error loading map: Resource at %s is not of type BiMap" % SAVE_PATH)
        as_player.play_warning()
        return

    mgr_map_data.forward.clear()
    var loaded_data: BiMap = loaded_resource as BiMap
    for cell: Vector2i in loaded_data.forward.keys():
        var data_record: DataRecord = loaded_data.get_data_tile(cell)
        var hex_tile: HexTileB = manger_mesh[data_record.multi_mesh_name]
        var pos: Vector3 = ManagerHextileGrid.hex_coordinates_to_point(cell, xz_plane_y)
        var data: DataRecord = hex_tile.add_instance_at(pos)
        mgr_map_data.add_pair(cell, data)
    print("Map loaded successfully.")

    if active_hex_tile:
        active_hex_tile.stop_preview()
        active_hex_tile = null
        active_hex_btn = null
    as_player.play_confirm()
    return
