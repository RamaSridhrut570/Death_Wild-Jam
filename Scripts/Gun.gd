extends Node3D

@export var bullet_scene: PackedScene

var target_angle: float = 0.0
var max_up_angle: float = 45.0
var min_down_angle: float = -45.0
var step: float = 10.0
var aim_speed: float = 15.0

var bullet_speed: float = 20.0

@onready var model_pivot = $ModelPivot
@onready var muzzle = $ModelPivot/Muzzle

func _unhandled_input(event: InputEvent) -> void:
    if not visible:
        return
        
    if Input.is_action_just_pressed("scroll_up"):
        target_angle += step
    elif Input.is_action_just_pressed("scroll_down"):
        target_angle -= step
    elif Input.is_action_just_pressed("fire_gun"):
        fire()
        


func _process(delta: float) -> void:
    if not visible:
        return
        
    var current_angle = rad_to_deg(model_pivot.rotation.y)
    var next_angle = lerp(current_angle, target_angle, aim_speed * delta)
    model_pivot.rotation.y = deg_to_rad(next_angle)

func fire() -> void:
    if not bullet_scene:
        return
    
    var bullet = bullet_scene.instantiate()
    # Add bullet to the main scene, not as a child of the gun
    get_tree().current_scene.add_child(bullet)
    
    bullet.global_transform = muzzle.global_transform
    
    # Fire the bullet forward (-Z is forward in Godot by default)
    var forward_dir = -bullet.global_transform.basis.z.normalized()
    bullet.linear_velocity = forward_dir * bullet_speed
