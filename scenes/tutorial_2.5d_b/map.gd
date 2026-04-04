@tool
extends Node3D

var total: int = 100
var size: float = 0.5
var w: float = sqrt(3) * size
var h: float = 1.5 * size #- 0.01
var offset: float = 0.50 * w

var scene_hexagon_sea: PackedScene = preload("res://scenes/tutorial_2.5d_b/hexagon_tile_sea.tscn")
var scene_hexagon_highland: PackedScene = preload("res://scenes/tutorial_2.5d_b/hexagon_tile_highland.tscn")
var scene_hexagon_plain: PackedScene = preload("res://scenes/tutorial_2.5d_b/hexagon_tile_plain.tscn")

var scene_hexagon_sea2: PackedScene = preload("res://scenes/tutorial_2.5d_b/hexagon.blend")
var scene_hexagon_highland2: PackedScene = preload("res://scenes/tutorial_2.5d_b/hexagon_highland.blend")
var scene_hexagon_plain2: PackedScene = preload("res://scenes/tutorial_2.5d_b/hexagon_plain.blend")

var scenes_array: Array[PackedScene]


func _ready() -> void:
    #scenes_array.append(scene_hexagon_sea)
    #scenes_array.append(scene_hexagon_highland)
    #scenes_array.append(scene_hexagon_plain)
    scenes_array.append(scene_hexagon_sea2)
    scenes_array.append(scene_hexagon_highland2)
    scenes_array.append(scene_hexagon_plain2)
    generate_hex_test()


func generate_hex_test() -> void:
    for x: int in total:
        for z: int in total:
            var hex = scenes_array[randi() % scenes_array.size()].instantiate()
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
