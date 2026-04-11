extends Resource

class_name DataHexTile

const MESH_LIB_PATH: String = "res://scenes/tutorial_3d_hex_grid/meshlibs/hexagon_tiles_with_border.meshlib"

@export var cell_loc: Vector2i = Vector2i.ZERO
@export var tile_name: String = ""
@export var tile_tex: Texture2D = null
@export_enum("HexLow", "HexMid", "HexHigh") var mesh_name: String = "HexMid"
@export var meshlib: MeshLibrary = preload(MESH_LIB_PATH)

var id: int = -1


func _init() -> void:
    # --- validate meshlib and mesh_name
    if meshlib == null:
        print("Error: MeshLibrary is not assigned in DataHexTile")
        return
    id = meshlib.find_item_by_name(mesh_name)
    if id == -1:
        print("Error: Tile with name %s is not found in meshlib at %s" % [mesh_name, MESH_LIB_PATH])
        return


func get_mesh() -> Mesh:
    if id == -1:
        return null
    return meshlib.get_item_mesh(id)


func get_item_shapes() -> Array:
    if id == -1:
        return []
    return meshlib.get_item_shapes(id)
