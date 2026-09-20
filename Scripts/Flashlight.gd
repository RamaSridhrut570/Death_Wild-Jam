extends Node3D

var target_angle: float = 0.0
var max_up_angle: float = 45.0
var min_down_angle: float = -45.0
var step: float = 10.0
var aim_speed: float = 15.0
var power=10
var maxp=12

@onready var r=get_parent().r

@onready var model_pivot = $ModelPivot

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
		
	if Input.is_action_just_pressed("scroll_up"):
		power+=1
		print(power)
		print($ModelPivot/SpotLight3D.light_energy)
	elif Input.is_action_just_pressed("scroll_down"):
		power+=1
		


func _process(delta: float) -> void:
	if not visible:
		return
	while power>0:
		power-=0.01*delta
		if power>1.2:
			power=1.1
	$ModelPivot/SpotLight3D.light_energy=power
	r=get_parent().r
	var current_angle = rad_to_deg(model_pivot.rotation.y)
	var next_angle = lerp(current_angle, target_angle, aim_speed * delta)
	model_pivot.rotation = r
