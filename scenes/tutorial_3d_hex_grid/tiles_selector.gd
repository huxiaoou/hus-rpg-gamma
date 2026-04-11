extends MarginContainer

class_name TilesSelector

@onready var tiles_container: HBoxContainer = $TilesContainer

func setup(scenes_database: Dictionary[String, PackedScene]) -> void:
    var database_size: int = scenes_database.size()

    var buttons: Array[ButtonTile] = []
    for child in tiles_container.get_children():
        if child is ButtonTile:
            buttons.append(child)
    var button_count: int = buttons.size()

    for i in range(min(button_count, database_size)):
        var button: ButtonTile = buttons[i]
        var tile_name: String = scenes_database.keys()[i]
        var scene: PackedScene = scenes_database[tile_name]
        var tile: HexTile = scene.instantiate()
        button.set_icon(tile.data.tile_tex)
            
