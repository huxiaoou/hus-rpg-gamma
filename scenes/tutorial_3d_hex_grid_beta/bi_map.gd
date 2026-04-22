extends Resource

class_name BiMap

@export var forward: Dictionary[Vector2i, DataRecord] = { }


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
