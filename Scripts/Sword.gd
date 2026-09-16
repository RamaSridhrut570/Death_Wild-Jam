extends Node3D

var target_angle: float = 0.0
var max_up_angle: float = 90.0 # Cocked back (pointing up)
var min_down_angle: float = -45.0 # Swung forward/down
var step: float = 35.0
var swing_speed: float = 20.0

@onready var handle_pivot = $HandlePivot

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
		
	if Input.is_action_just_pressed("scroll_up"):
		# Scroll back -> pull sword back (up)
		target_angle += step
	elif Input.is_action_just_pressed("scroll_down"):
		# Scroll front -> swing sword forward (down)
		target_angle -= step
		
	target_angle = clamp(target_angle, min_down_angle, max_up_angle)

func _process(delta: float) -> void:
	if not visible:
		return
		
	# Smoothly rotate around the local X axis
	var current_angle = rad_to_deg(handle_pivot.rotation.x)
	var next_angle = lerp(current_angle, target_angle, swing_speed * delta)
	handle_pivot.rotation.x = deg_to_rad(next_angle)
