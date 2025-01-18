extends Node3D

@export var horizontal_acceleration := 2.0
@export var vertical_acceleration := 1.0


func _process(delta: float) -> void:
	var joy_dir = Input.get_vector("pan_left", "pan_right", "pan_up", "pan_down")
	rotate_from_vector(joy_dir * delta * Vector2(horizontal_acceleration, vertical_acceleration))
	#print(joy_dir)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_from_vector(event.relative * 0.005)
	
		#print("mouse movement: ", event.relative)

func rotate_from_vector(v: Vector2):
	if v.length() == 0: return
	# left/right camera pan
	rotation.y -= v.x
	#rotation.y += v.x # this can be an option based on player preference
	
	# up/down camera pan with limits
	rotation.x -= v.y
	rotation.x = clamp(rotation.x, -0.1, 0.1)