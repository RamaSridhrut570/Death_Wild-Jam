extends RigidBody3D

var lifespan = 3.0
var timer = 0.0

func _process(delta):
    timer += delta
    if timer >= lifespan:
        queue_free()
