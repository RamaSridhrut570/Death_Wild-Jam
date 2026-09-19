# This script just deals with player movement, camera movement is in the CamOrigin script.

extends CharacterBody3D

# Movement settings
var speed: float = 10.0
var turn_speed: float = 30.0

# Gravity settings
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

# Parent reference
var parent: Node3D

var is_dead: bool = false

@onready var flashlight: Node3D = $"../Flashlight"
@onready var sword: Node3D = $"../Sword"
@onready var gun: Node3D = $"../Gun"
@onready var inventory_ui: Control = $"../UI/InventoryUI"

@export_group("Jump")
@export var jump_height: float = 3.0
@export var time_to_peak: float = 0.3
@export var time_to_fall: float = 0.25
@export var max_fall_speed: float = 1000.0

# Calculated jump values
var jump_velocity: float = 0.0
var jump_gravity: float = 0.0
var fall_gravity: float = 0.0

@onready var cam_h: Node3D = $"../CamOrigin/h"
@onready var cam_v: Node3D = $"../CamOrigin/h/v"

func _ready() -> void:
	# Calculate jump physics
	_calculate_jump_physics()
	
	# Set mouse mode captured so it locks in middle of screen
	capture_mouse()
	
	# Set parent reference
	parent = get_parent()

func _calculate_jump_physics() -> void:
	# Calculate jump velocity and gravity based on height and time parameters
	jump_velocity = (2.0 * jump_height) / time_to_peak
	jump_gravity = (2.0 * jump_height) / (time_to_peak * time_to_peak)
	fall_gravity = (2.0 * jump_height) / (time_to_fall * time_to_fall)

func _apply_gravity(delta: float) -> void:
	if is_on_floor() and velocity.y <= 0.0:
		velocity.y = 0.0
		return
	
	# Use different gravity values based on whether the player is going up or down
	var current_gravity = fall_gravity if velocity.y <= 0.0 else jump_gravity
	velocity.y = max(velocity.y - (current_gravity * delta), -max_fall_speed)

func _unhandled_input(event: InputEvent) -> void:
	# If "exit" (esc) is pressed, close game
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
	# Jump input
	
	# Lighter boost input
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_dead:
		velocity.y = jump_velocity

func _process(delta: float) -> void:
	# Set parent position to equal CharacterBody position every frame
	if parent:
		parent.position = position
	
	var active_item = inventory_ui.get_selected_item_name()
	
	
	if sword:
		sword.visible = (active_item == "Sword") and not is_dead
		
	if gun:
		gun.visible = (active_item == "Gun") and not is_dead
		
	if flashlight:
		flashlight.visible = (active_item == "Flashlight") and not is_dead

func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	
	# Turn player inputs into a vector
	var input_dir := Vector2.ZERO
	if not is_dead:
		input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	
	# Use input_dir movement vector to know which direction the player is facing,
	# depending on the camera rotation
	var direction := (cam_h.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction.length() > 0.0:
		# Player movement
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		
		# Change player model rotation (smooth rotation)
		var target_angle := atan2(-direction.x, -direction.z)
		rotation.y = lerp_angle(rotation.y, target_angle, turn_speed * delta)
	else:
		# If no direction input, decelerate the player
		velocity.x = move_toward(velocity.x, 0.0, speed)
		velocity.z = move_toward(velocity.z, 0.0, speed)
	
	move_and_slide()

func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func release_mouse() -> void:
	# Not used anywhere in this demo, but you probably will want to run this func for menus and stuff
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
