extends Resource

class_name DataHexTileB

enum HexType {
    HEXLOW,
    HEXMID,
    HEXHIGH,
}

@export var multi_mesh_name: String = ""
@export var tex: Texture2D = null
@export var hextileb_lib: MeshLibrary = preload("res://scenes/tutorial_3d_hex_grid_beta/meshlibs/hextiles.meshlib")
@export_enum("HexLow", "HexMid", "HexHigh") var hex_type: String = "HexMid"
@export var max_count: int = 10000

var hex_name: String:
    get:
        return multi_mesh_name.split("_")[0] if multi_mesh_name else ""


func get_mesh() -> Mesh:
    if not hextileb_lib:
        return null

    var mesh_id: int = hextileb_lib.find_item_by_name(hex_type)
    if mesh_id == -1:
        return null
    var lib_mesh: Mesh = hextileb_lib.get_item_mesh(mesh_id)
    return lib_mesh


func get_hex_type_enum() -> HexType:
    match hex_type:
        "HexLow":
            return HexType.HEXLOW
        "HexMid":
            return HexType.HEXMID
        "HexHigh":
            return HexType.HEXHIGH
    return HexType.HEXMID


static func get_hex_type(hex_type_int: HexType) -> String:
    match hex_type_int:
        HexType.HEXLOW:
            return "HexLow"
        HexType.HEXMID:
            return "HexMid"
        HexType.HEXHIGH:
            return "HexHigh"
    return "HexMid"


static func get_hex_types() -> Array[String]:
    var res: Array[String] = []
    for hex_type_int in HexType.values():
        res.append(get_hex_type(hex_type_int))
    return res
