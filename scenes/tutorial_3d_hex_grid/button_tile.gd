extends Button

class_name ButtonTile

@onready var custom_icon: TextureRect = $CustomIcon
@onready var activated: bool = false
 

func set_icon(tex_icon: Texture2D) -> void:
    custom_icon.texture = tex_icon


func _on_pressed() -> void:
    print("Button Tile Pressed")
    activated = !activated
    
