extends VBoxContainer

class_name UIHextileLegend

@onready var texture: TextureRect = $Texture
@onready var label: Label = $Label

var full_name: String = ""


func setup(icon_name: String, icon_tex: Texture2D) -> void:
    full_name = icon_name
    label.text = full_name.substr(3)
    texture.texture = icon_tex


func _get_drag_data(_at_position: Vector2) -> Variant:
    print("Icon dragged")

    var preview: TextureRect = texture.duplicate()
    var preview_container: Control = Control.new()
    preview_container.add_child(preview)
    preview.position = -0.5 * preview.custom_minimum_size

    set_drag_preview(preview_container)

    return { "icon_tex": texture.texture, "hex_name": full_name }
