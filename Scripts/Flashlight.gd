extends Node3D

var target_angle: float = 0.0
var max_up_angle: float = 45.0
var min_down_angle: float = -45.0
var step: float = 10.0
var aim_speed: float = 15.0

@onready var model_pivot = $ModelPivot

func _unhandled_input(event: InputEvent) -> void:
    if not visible:
        return
        
    if Input.is_action_just_pressed("scroll_up"):
        target_angle += step
    elif Input.is_action_just_pressed("scroll_down"):
        target_angle -= step
        


func _process(delta: float) -> void:
    if not visible:
        return
        
    var current_angle = rad_to_deg(model_pivot.rotation.y)
    var next_angle = lerp(current_angle, target_angle, aim_speed * delta)
    model_pivot.rotation.y = deg_to_rad(next_angle)
