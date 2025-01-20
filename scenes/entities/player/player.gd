extends CharacterBody3D

@export var jump_height: float = 2.25
@export var jump_time_to_peak: float = 0.4
@export var jump_time_to_descent: float = 0.3

@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

@export var base_speed := 4.0
@export var run_speed := 6.0
@export var camera: Node3D

var movement_input := Vector2.ZERO # Vector2(0, 0)

func _ready() -> void:
	var connected_devices = Input.get_connected_joypads()
	if connected_devices.is_empty():
		print("No controllers detected.")
	else:
		print("Connected controllers: ", connected_devices)

func _input(event):
	if event is InputEventJoypadMotion:
		print("Joypad ", event.device," Motion Detected: ", event.axis, " Value: ", event.axis_value)
	elif event is InputEventJoypadButton:
		print("Joypad ", event.device,"  Button Pressed: ", event.button_index, " Pressed: ", str(event.pressed))

func _physics_process(delta: float) -> void:
	#velocity = Vector3(movement_input.x, 0, movement_input.y) * base_speed
	move_logic(delta)
	jump_logic(delta)
	move_and_slide()

func move_logic(delta) -> void:
	movement_input = Input.get_vector("left", "right", "forward", "backward").rotated(-camera.global_rotation.y)
	var vel_2d = Vector2(velocity.x, velocity.z)
	var is_running: bool = Input.is_action_pressed("run")
	
	if movement_input != Vector2.ZERO: # if there is movement input vector, accelerate to base_speed
		var speed = run_speed if is_running else base_speed
		vel_2d += movement_input * speed * delta
		vel_2d = vel_2d.limit_length(speed)
		velocity.x = vel_2d.x
		velocity.z = vel_2d.y
	else: # if no movement input, decelerate to zero vector
		vel_2d = vel_2d.move_toward(Vector2.ZERO, base_speed * 4.0 * delta)
		velocity.x = vel_2d.x
		velocity.z = vel_2d.y
		
func jump_logic(delta) -> void:
	# for better UX, add a grace buffer for jump inputs made close to floor instead of a strict check
	# should input handling be done before or after is_on_floor() check?
	# how should exploits be mitigated? (jump spam, early jumps, etc.) how do other games handle this and also
	# implement other movement mechanics?
	if is_on_floor(): 
		if Input.is_action_just_pressed("jump"):
			velocity.y = -jump_velocity
	var gravity = jump_gravity if velocity.y > 0.0 else fall_gravity
	velocity.y -= gravity * delta
		
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
