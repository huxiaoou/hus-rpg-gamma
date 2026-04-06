@tool
extends Node3D

var total: int = 100
var size: float = 0.5
var w: float = sqrt(3) * size # + 0.01
var h: float = 1.5 * size #- 0.01
var offset: float = 0.50 * w

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


func _ready() -> void:
    generate_hex_test()


func generate_hex_test() -> void:
    var scenes_array_size: int = scenes_array.size()
    for x: int in total:
        for z: int in total:
            var id: int = randi_range(0, scenes_array_size - 1)
            var hex: HexTile = scenes_array[id].instantiate()
            add_child(hex)
            if z % 2 == 0:
                hex.global_position = Vector3(x * w, 0, h * z)
            else:
                hex.global_position = Vector3(x * w + offset, 0, h * z)
