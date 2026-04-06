@tool
extends Node3D

var total: int = 100
var size: float = 0.5
var w: float = sqrt(3) * size # + 0.01
var h: float = 1.5 * size #- 0.01
var offset: float = 0.50 * w


var meshlib: MeshLibrary = preload("res://scenes/tutorial_3d_hex_grid/hexagon_tiles_with_border2.meshlib")
var scenes_array: Array[PackedScene]


func _ready() -> void:
    generate_hex_test()
    pass

func get_hex(id:int) -> MeshInstance3D:
    var hex: MeshInstance3D = MeshInstance3D.new()
    hex.mesh = meshlib.get_item_mesh(id)
    hex.transform = hex.transform.rotated(Vector3i(0, 1, 0), -2*PI/3)
    
    var static_body: StaticBody3D = StaticBody3D.new()
    hex.add_child(static_body)
    var collision_data = meshlib.get_item_shapes(id)
    for i:int in range(0, collision_data.size(), 2):
        var shape_res:Shape3D = collision_data[i]      # The actual Shape (Box, Convex, etc.)
        var shape_transform:Transform3D = collision_data[i+1] # The offset/rotation of that shape
        var collision_node = CollisionShape3D.new()
        collision_node.shape = shape_res
        collision_node.transform = shape_transform
        static_body.add_child(collision_node)
    return hex

func generate_hex_test() -> void:
    var meshlib_size: int = meshlib.get_item_list().size()
    for x: int in total:
        for z: int in total:
            var id: int = randi_range(0, meshlib_size -1)
            var hex: MeshInstance3D = get_hex(id)
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
