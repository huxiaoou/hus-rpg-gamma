extends VBoxContainer

class_name TileLegend

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label


func _get_drag_data(_at_position: Vector2) -> Variant:
    print("Icon dragged")

    var preview: TextureRect = texture_rect.duplicate()
    var preview_container: Control = Control.new()
    preview_container.add_child(preview)
    preview.position = -0.5 * preview.custom_minimum_size

    set_drag_preview(preview_container)

    return { "icon_tex": texture_rect.texture, "tile_name": label.text }
