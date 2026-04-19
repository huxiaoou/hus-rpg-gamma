extends Button

class_name ButtonHextileB

signal btn_hextile_pressed(multi_mesh_name: String)

@export var data: DataBtnHextile
var multi_mesh_name: String:
    get:
        return data.multi_mesh_name if data else ""

@onready var hextype_bar: ProgressBar = $HextypeBar

const MIN_COLOR: Color = Color(0.0, 0.5, 0.8)
const MAX_COLOR: Color = Color(0.0, 0.5, 0.2)


func setup(_data: DataBtnHextile) -> void:
    data = _data
    icon = data.icon
    return


func set_hex_type(new_type: DataHexTileB.HexType) -> void:
    var ary: Array = DataHexTileB.HexType.values()
    var min_val: int = ary.min()
    var max_val: int = ary.max()

    data.hex_type = clampi(new_type, min_val, max_val) as DataHexTileB.HexType
    hextype_bar.value = data.hex_type + 1.0
    var w: float = (data.hex_type - min_val) / float(max_val - min_val)
    hextype_bar.modulate = MIN_COLOR.lerp(MAX_COLOR, w)
    return


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("debug_test_increase"):
        var new_type: DataHexTileB.HexType = (data.hex_type + 1) as DataHexTileB.HexType
        set_hex_type(new_type)
    elif event.is_action_pressed("debug_test_decrease"):
        var new_type: DataHexTileB.HexType = (data.hex_type - 1) as DataHexTileB.HexType
        set_hex_type(new_type)
    return


func _on_pressed() -> void:
    print("Button pressed: %s" % multi_mesh_name)
    btn_hextile_pressed.emit(multi_mesh_name)
    return
