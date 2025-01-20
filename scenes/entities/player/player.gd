extends CharacterBody3D

@export var base_speed := 4.0
@export var camera: Node3D
@export var controller_index: int = 0

var movement_input := Vector2.ZERO

func _ready() -> void:
	var connected_devices = Input.get_connected_joypads()
	if connected_devices.is_empty():
		print("No controllers detected.")
	else:
		print("Connected controllers: ", connected_devices)
		print("Using controller index: ", controller_index)

func _input(event):
	if event is InputEventJoypadMotion:
		print("Joypad Motion Detected:", event.axis, "Value:", event.axis_value)
	elif event is InputEventJoypadButton:
		print("Joypad Button Pressed:", event.button_index, "Pressed:", event.pressed)

func _physics_process(_delta: float) -> void:
	movement_input = Input.get_vector("left", "right", "forward", "backward").rotated(-camera.global_rotation.y)
	velocity = Vector3(movement_input.x, 0, movement_input.y) * base_speed
	move_and_slide()
	
	#print(camera.global_rotation.y)
	#print("movement input vector: ", movement_input)
		
#region default template (commented)
#const SPEED = 5.0
#const JUMP_VELOCITY = 4.5
#
#func _physics_process(delta):
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)
#
	#move_and_slide()
#endregion
