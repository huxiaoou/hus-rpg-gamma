extends Node3D

@onready var mesh3d: MeshInstance3D = $Cylinder

@export var tex: Texture2D 

func _ready() -> void:
    set_tex()
    
func set_tex() -> void:
    var mat: StandardMaterial3D = mesh3d.get_active_material(0).duplicate()
    mat.albedo_texture = tex
    mesh3d.set_surface_override_material(0, mat)
