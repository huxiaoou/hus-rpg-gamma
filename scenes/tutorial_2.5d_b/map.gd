@tool
extends Node3D

var size: float = 0.5
var w: float = sqrt(3) * size
var h: float = 1.5 * size #- 0.01
var offset: float = 0.50 * w

var scene_hexagon_highland: PackedScene = preload("res://scenes/tutorial_2.5d_b/hexagon_tile_highland.tscn")
var scene_hexagon_sea: PackedScene = preload("res://scenes/tutorial_2.5d_b/hexagon_tile_sea.tscn")
var scene_hexagon_plain: PackedScene = preload("res://scenes/tutorial_2.5d_b/hexagon_tile_plain.tscn")
var scenes_array: Array[PackedScene]

func _ready() -> void:
    scenes_array.append(scene_hexagon_highland)
    scenes_array.append(scene_hexagon_sea)
    scenes_array.append(scene_hexagon_plain)
    generate_hex_test()
    


func generate_hex_test() -> void:
    var total: int = 6
    for x: int in total:
        for z: int in total:
            var hex: Hexgon = scenes_array[randi()%3].instantiate()
            add_child(hex)
            if z % 2 == 0:
                hex.global_position = Vector3(x * w, 0, h * z)
            else:
                hex.global_position = Vector3(x * w + offset, 0, h * z)

        #for z: int in total:
        #if x % 2 == 0:
        #hex.global_transform.origin = Vector3(w*x, 0, h*z)
        #print("even")
        #else:
        #hex.global_transform.origin = Vector3( (w*offest)*x , 0, (0.87*h)*z + offest)
        #print("odd")
