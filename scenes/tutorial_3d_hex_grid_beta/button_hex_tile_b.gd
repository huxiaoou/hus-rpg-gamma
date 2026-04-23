extends Button

class_name ButtonHextileB

signal btn_hextile_pressed(multi_mesh_name: String, btn: ButtonHextileB)

@export var data: DataBtnHextile
var multi_mesh_name: String:
    get:
        return data.multi_mesh_name if data else ""
var ary: Array = DataHexTileB.HexType.values()
var min_val: int = ary.min()
var max_val: int = ary.max()

@onready var hextype_bar: ProgressBar = $HextypeBar
@onready var label: Label = $Label

const MIN_COLOR: Color = Color(0.0, 0.5, 0.8)
const MAX_COLOR: Color = Color(0.0, 0.5, 0.2)


func setup(_data: DataBtnHextile) -> void:
    data = _data
    icon = data.icon
    return


func display_shortcut():
    if shortcut and not shortcut.events.is_empty():
        var event: InputEvent = shortcut.events[0]
        if event is InputEventKey:
            label.text = event.as_text_keycode()


func set_hex_type(new_type: DataHexTileB.HexType) -> bool:
    if new_type > max_val or new_type < min_val:
        print("Invalid hex type: ", new_type)
        return false

    data.hex_type = new_type
    hextype_bar.value = data.hex_type + 1.0
    var w: float = (data.hex_type - min_val) / float(max_val - min_val)
    hextype_bar.modulate = MIN_COLOR.lerp(MAX_COLOR, w)
    return true


func _on_pressed() -> void:
    print("Button pressed: %s" % multi_mesh_name)
    btn_hextile_pressed.emit(multi_mesh_name, self)
    return


func increase_hex_type() -> bool:
    return set_hex_type(data.hex_type + 1)


func decrease_hex_type() -> bool:
    return set_hex_type(data.hex_type - 1)


func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
    if _data is Dictionary:
        if _data.has("icon_tex") and _data.has("hex_name"):
            return true
        return false
    return false


func _drop_data(_at_position: Vector2, _data: Variant) -> void:
    print("Tile dropped: %s" % _data["hex_name"])
    var new_data: DataBtnHextile = DataBtnHextile.new()
    new_data.icon = _data["icon_tex"]
    new_data.hex_name = _data["hex_name"]
    new_data.hex_type = data.hex_type if data else DataHexTileB.HexType.HEXMID
    setup(new_data)
    return
