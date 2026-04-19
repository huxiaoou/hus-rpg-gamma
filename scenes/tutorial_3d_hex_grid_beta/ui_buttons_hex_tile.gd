extends MarginContainer

class_name UIButtonsHextileB

@onready var h_box_container: HBoxContainer = $HBoxContainer

var scene_btn: PackedScene = preload("res://scenes/tutorial_3d_hex_grid_beta/button_hex_tile_b.tscn")
const BTN_SHORTCUT_RES_DIR: String = "res://scenes/tutorial_3d_hex_grid_beta/resources/btns/"


func _ready() -> void:
    setup()


func setup() -> void:
    var dir: DirAccess = DirAccess.open(BTN_SHORTCUT_RES_DIR)
    if not dir:
        print("Failed to open directory: ", BTN_SHORTCUT_RES_DIR)
        return

    dir.list_dir_begin()
    for file: String in dir.get_files():
        if not file.ends_with(".tres"):
            continue

        var shortcut: Shortcut = load(BTN_SHORTCUT_RES_DIR + "/" + file) as Shortcut
        var btn: ButtonHextileB = scene_btn.instantiate()
        h_box_container.add_child(btn)
        btn.shortcut = shortcut
