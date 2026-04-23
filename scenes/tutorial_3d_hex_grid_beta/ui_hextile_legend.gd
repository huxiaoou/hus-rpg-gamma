extends VBoxContainer

class_name UIHextileLegend

@onready var texture: TextureRect = $Texture
@onready var label: Label = $Label


func setup(icon_name: String, icon_tex: Texture2D) -> void:
    label.text = icon_name
    texture.texture = icon_tex


func _get_drag_data(_at_position: Vector2) -> Variant:
    print("Icon dragged")

    var preview: TextureRect = texture.duplicate()
    var preview_container: Control = Control.new()
    preview_container.add_child(preview)
    preview.position = -0.5 * preview.custom_minimum_size

    set_drag_preview(preview_container)

    return { "icon_tex": texture.texture, "hex_name": label.text }
