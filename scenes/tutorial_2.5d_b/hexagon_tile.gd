extends MeshInstance3D

class_name Hexgon

@export var tex: Texture2D
@export_range(0.1, 5, 0.1) var radius: float = 0.5
@export_range(0.05, 0.5, 0.05) var height: float = 0.2
@export var uv1_scale: Vector3 = Vector3(2.35, 1.34, 2.0)
@export var uv1_offset: Vector3 = Vector3(-0.09, 0.66, 0)


func _ready() -> void:
    if mesh is CylinderMesh:
        mesh.top_radius = radius
        mesh.bottom_radius = radius
        mesh.height = height
        mesh.radial_segments = 6
        
        var mat:StandardMaterial3D = get_active_material(0)
        mat.albedo_texture = tex
        mat.uv1_scale = uv1_scale
        mat.uv1_offset = uv1_offset
