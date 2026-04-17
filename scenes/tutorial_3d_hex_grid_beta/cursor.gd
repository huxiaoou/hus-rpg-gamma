extends Sprite3D

class_name Cursor

func update_pos_from_hex_coords(hex_coords: Vector2i) -> void:
    var hex_center_pos: Vector3 = ManagerHextileGrid.hex_coordinates_to_point(
        hex_coords,
        global_position.y,
    )
    global_position = hex_center_pos
    return
