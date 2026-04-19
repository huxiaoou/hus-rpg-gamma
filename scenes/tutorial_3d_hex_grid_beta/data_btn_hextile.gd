extends Resource

class_name DataBtnHextile

@export var icon: Texture2D = null
@export var hex_name: String = ""
@export var hex_type: DataHexTileB.HexType = DataHexTileB.HexType.HEXMID

var hex_type_str: String:
    get:
        return DataHexTileB.get_hex_type(hex_type)

var multi_mesh_name: String:
    get:
        return "%s_%s" % [hex_name, hex_type_str]
