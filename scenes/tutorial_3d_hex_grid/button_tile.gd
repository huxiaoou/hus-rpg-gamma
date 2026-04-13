extends Button

class_name ButtonTile

signal scene_selected(scene_name: String)
signal button_activated(button: ButtonTile)
signal button_deactivated(button: ButtonTile)

@onready var custom_icon: TextureRect = $CustomIcon
@onready var activated: bool = false

var scene_name: String = ""


func setup(icon_tex: Texture2D, tile_name: String) -> void:
    custom_icon.texture = icon_tex
    scene_name = tile_name
    return


func _on_pressed() -> void:
    activated = !activated
    if activated:
        scene_selected.emit(scene_name)
        button_activated.emit(self)
        print("Tile selected: %s" % scene_name)
    else:
        scene_selected.emit("")
        button_deactivated.emit(self)
        print("Tile deselected: %s" % scene_name)
    return


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("cancel_hex_selection") and activated:
        print("aaa")
        _on_pressed()
    return


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
    if data is Dictionary:
        if data.has("icon_tex") and data.has("tile_name"):
            return true
        return false
    return false


func _drop_data(_at_position: Vector2, data: Variant) -> void:
    print("Tile dropped: %s" % data["tile_name"])
    setup(data["icon_tex"], data["tile_name"])
    return
