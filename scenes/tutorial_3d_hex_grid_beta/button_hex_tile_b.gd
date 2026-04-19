extends Button

class_name ButtonHextileB

@onready var hextype_bar: ProgressBar = $HextypeBar

const MIN_COLOR: Color = Color(0.0, 0.5, 0.8)
const MAX_COLOR: Color = Color(0.0, 0.5, 0.2)

@export var multi_mesh_name: String = "hexBase00_HexMid"
var hex_type: DataHexTileB.HexType

func _ready() -> void:
    set_hex_type(DataHexTileB.HexType.HEXMID)


func set_hex_type(new_type: DataHexTileB.HexType) -> void:
    var ary: Array = DataHexTileB.HexType.values()
    var min_val: int = ary.min()
    var max_val: int = ary.max()
    hex_type = clampi(new_type, min_val, max_val) as DataHexTileB.HexType
    hextype_bar.value = hex_type + 1.0
    var w: float = (new_type - min_val) / float(max_val - min_val)
    hextype_bar.modulate = MIN_COLOR.lerp(MAX_COLOR, w)
    return


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("debug_test_increase"):
        var new_type: DataHexTileB.HexType = (hex_type + 1) as DataHexTileB.HexType
        set_hex_type(new_type)
    elif event.is_action_pressed("debug_test_decrease"):
        var new_type: DataHexTileB.HexType = (hex_type - 1) as DataHexTileB.HexType
        set_hex_type(new_type)
    return

func _on_pressed() -> void:
    print("Button pressed: %s" % multi_mesh_name)
