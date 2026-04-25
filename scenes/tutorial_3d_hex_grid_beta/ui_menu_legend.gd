extends PanelContainer

class_name UIMenuLegend

@export var scene_hextile_legend: PackedScene = preload("res://scenes/tutorial_3d_hex_grid_beta/ui_hextile_legend.tscn")
@onready var grid_container: GridContainer = $MarginContainer/VBoxContainer/ScrollContainer/GridContainer


func setup(manger_mesh: Dictionary[String, HexTileB]) -> void:
    for multi_mesh_name: String in manger_mesh.keys():
        var elements: PackedStringArray = multi_mesh_name.split("_")
        var mesh_name: String = elements[0]
        var mesh_type: String = elements[1]
        if mesh_type != "HexMid":
            continue
        
        var hextile: HexTileB = manger_mesh[multi_mesh_name]
        var legend: UIHextileLegend = scene_hextile_legend.instantiate()
        grid_container.add_child(legend)
        legend.setup(mesh_name, hextile.data.tex)

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("toggle_menu"):
        print("aaa")
        visible = !visible
