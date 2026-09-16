extends CharacterBody2D


@export_group("Movement")
@export var speed: float = 2000.0
@export var acceleration: float
@export var max_fall_speed: float = 1000.0

@export_group("Jump")
@export var jump_height: float = 250.0
@export var time_to_peak: float = 0.3
@export var time_to_fall: float = 0.25
@export var max_jumps: int = 2

@export_group("Recoil")
@export var recoil_impulse: float = 600.0

var jump_velocity: float
var jump_gravity: float
var fall_gravity: float
var jump_count: int = 0


func _ready() -> void:
	pass


func _recalculate_jump_values() -> void:
	var effective_time_to_fall: float = maxf(time_to_fall / float(jump_count + 1), 0.01)
	jump_velocity = (2.0 * jump_height) / time_to_peak
	jump_gravity = (2.0 * jump_height) / (time_to_peak * time_to_peak)
	fall_gravity = (2.0 * jump_height) / (effective_time_to_fall * effective_time_to_fall)


func _process(_delta: float) -> void:
	acceleration = speed * 5
	_recalculate_jump_values()


func _physics_process(delta: float) -> void:
	up_direction = Vector2.UP

	if is_on_floor():
		jump_count = 0

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not is_on_floor():
		var recoil_direction := (global_position - get_global_mouse_position()).normalized()
		velocity += recoil_direction * recoil_impulse

	# Apply stronger gravity while falling and lighter gravity while the jump is held.
	if not is_on_floor():
		var gravity := jump_gravity
		if velocity.y > 0.0:
			gravity = fall_gravity
		#elif not Input.is_action_pressed("ui_accept"):
			#gravity = fall_gravity
		velocity.y += gravity * delta
		velocity.y = clamp(velocity.y, -jump_velocity, max_fall_speed)

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and jump_count < max_jumps:
		velocity.y = -jump_velocity
		jump_count += 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration * delta)

	velocity.x = clamp(velocity.x, -speed, speed)

	move_and_slide()
