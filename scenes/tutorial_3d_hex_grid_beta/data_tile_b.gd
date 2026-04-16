extends Resource

class_name DataTileB

@export var multi_mesh_name: String = ""
@export var id: int = -1


func is_equal(other: DataTileB) -> bool:
    return multi_mesh_name == other.multi_mesh_name and id == other.id
