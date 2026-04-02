@tool
extends MeshInstance3D

class_name MeshHexagon

func _ready():
    var st = SurfaceTool.new()
    st.begin(Mesh.PRIMITIVE_TRIANGLES)
    
    var radius = 1.0
    var center = Vector3.ZERO
    
    # 1. Define the 6 outer vertices
    var vertices = []
    for i in range(6):
        var angle_deg = 60 * i - 30 # -30 rotates it to "pointy top"
        var angle_rad = deg_to_rad(angle_deg)
        var v = Vector3(cos(angle_rad), 0, sin(angle_rad)) * radius
        vertices.append(v)

    # 2. Build the 6 triangles (fan style)
    for i in range(6):
        # UVs: Map the -1.0 to 1.0 range to 0.0 to 1.0
        var uv_center = Vector2(0.5, 0.5)
        var uv1 = Vector2(vertices[i].x, vertices[i].z) / (radius * 2) + Vector2(0.5, 0.5) + Vector2(0, 0.2)
        var uv2 = Vector2(vertices[(i + 1) % 6].x, vertices[(i + 1) % 6].z) / (radius * 2) + Vector2(0.5, 0.5) + Vector2(0, 0.2)

        # Add Center Point
        st.set_uv(uv_center)
        st.add_vertex(center)
        
        # Add current vertex
        st.set_uv(uv1)
        st.add_vertex(vertices[i])
        
        # Add next vertex
        st.set_uv(uv2)
        st.add_vertex(vertices[(i + 1) % 6])

    st.generate_normals()
    mesh = st.commit()
