extends Resource

class_name DataRecord

@export var multi_mesh_name: String = ""
@export var id: int = -1


func is_equal(other: DataRecord) -> bool:
    return multi_mesh_name == other.multi_mesh_name and id == other.id
