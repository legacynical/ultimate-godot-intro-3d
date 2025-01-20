extends Node3D

@export var min_limit_x: float
@export var max_limit_x: float
@export var horizontal_acceleration := 2.0
@export var vertical_acceleration := 1.0
@export var mouse_acceleration := 0.005
@export var joy_stick_control: bool

# note: there can be glitchy camera movement if both _process() (which handles joystick input) and 
# _input() (which handles mouse input) are active. This can be mitigated by activating one at a
# time with additional code logic or by sticking to using whichever of the two. I'll just leave
# both active for now for testing purposes

func _process(delta: float) -> void:
	if joy_stick_control:
		var joy_dir = Input.get_vector("pan_left", "pan_right", "pan_up", "pan_down")
		rotate_from_vector(joy_dir * delta * Vector2(horizontal_acceleration, vertical_acceleration))
		#print(joy_dir)

func _input(event: InputEvent) -> void:
	if not joy_stick_control:
		if event is InputEventMouseMotion:
			rotate_from_vector(event.relative * mouse_acceleration)
			#print("mouse movement: ", event.relative)

func rotate_from_vector(v: Vector2):
	if v.length() == 0: return
	# left/right camera pan
	rotation.y -= v.x
	#rotation.y += v.x # this can be an option based on player preference
	
	# up/down camera pan with limits
	rotation.x -= v.y
	rotation.x = clamp(rotation.x, min_limit_x, max_limit_x)
