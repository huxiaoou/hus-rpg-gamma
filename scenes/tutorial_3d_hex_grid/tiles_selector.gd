extends MarginContainer

class_name TilesSelector

@onready var tiles_container: HBoxContainer = $TilesContainer

var active_button: ButtonTile = null


func _ready() -> void:
    for button: ButtonTile in get_buttons():
        button.button_activated.connect(on_button_activated)
        button.button_deactivated.connect(on_button_deactivated)
    return


func get_buttons() -> Array[ButtonTile]:
    var buttons: Array[ButtonTile] = []
    for child in tiles_container.get_children():
        if child is ButtonTile:
            buttons.append(child)
    return buttons


func on_button_activated(button: ButtonTile) -> void:
    if active_button == null:
        active_button = button
        return
    if active_button != button:
        active_button.activated = false
        print("Tile deselected: %s" % active_button.scene_name)
    active_button = button
    return


func on_button_deactivated(button: ButtonTile) -> void:
    if active_button == button:
        active_button = null
    return


func setup(scenes_database: Dictionary[String, PackedScene]) -> void:
    var database_size: int = scenes_database.size()
    var buttons: Array[ButtonTile] = get_buttons()
    var button_count: int = buttons.size()

    for i in range(min(button_count, database_size)):
        var button: ButtonTile = buttons[i]
        var scene_name: String = scenes_database.keys()[i]
        var scene: PackedScene = scenes_database[scene_name]
        button.setup(scene)
    return
