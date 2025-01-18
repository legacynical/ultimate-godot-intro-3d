extends MeshInstance3D

func _ready() -> void:
	var material = mesh.surface_get_material(0)
	material.albedo_color = Color.GREEN
	
	mesh.outer_radius = 5
	
func _physics_process(delta: float) -> void:
	# rotate_y(0.1)
	rotation_degrees += Vector3(0, 1, 0)
	position += Vector3(1, 0, 0) * delta
	scale += Vector3(0.01, 0.01, 0.01) * delta
	
