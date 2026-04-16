extends Node

var size: float = 0.5
var w: float = sqrt(3) * size # + 0.01
var h: float = 1.5 * size #- 0.01
var offset: float = 0.50 * w


func point_to_hex_coordinates(point: Vector3) -> Vector2i:
    var r: int = roundi(point.z / h)
    var q: int = roundi((point.x - offset * int(r % 2 != 0)) / w)
    return Vector2i(q, r)


func hex_coordinates_to_point(hex_coords: Vector2i, xz_plane_y: float = 0.0) -> Vector3:
    var x: float = hex_coords.x * w + offset * int(hex_coords.y % 2 != 0)
    var z: float = hex_coords.y * h
    return Vector3(x, xz_plane_y, z)


func get_xz_projection(xz_plane_y: float = 0.0) -> Vector3:
    var camera: Camera3D = get_viewport().get_camera_3d()
    if camera == null:
        return Vector3.INF
    var mouse_pos: Vector2 = get_viewport().get_mouse_position()
    var ray_origin: Vector3 = camera.project_ray_origin(mouse_pos)
    var ray_direction: Vector3 = camera.project_ray_normal(mouse_pos)
    var plane: Plane = Plane(Vector3.UP, xz_plane_y)
    var intersection: Variant = plane.intersects_ray(ray_origin, ray_direction)
    if intersection == null:
        return Vector3.INF
    return intersection
