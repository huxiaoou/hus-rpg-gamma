extends Button

class_name ButtonTile

signal scene_selected(scene_name: String)
signal button_activated(button: ButtonTile)
signal button_deactivated(button: ButtonTile)

@onready var custom_icon: TextureRect = $CustomIcon
@onready var activated: bool = false

var scene_name: String = ""


func setup(scene: PackedScene) -> void:
    var tile: HexTile = scene.instantiate()
    custom_icon.texture = tile.data.tile_tex
    scene_name = tile.data.tile_name
    tile.queue_free()


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
