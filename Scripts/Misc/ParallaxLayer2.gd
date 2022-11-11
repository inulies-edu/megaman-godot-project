extends ParallaxLayer


var cloud_speed : float = -20.0

func _physics_process(delta):
	motion_offset.x += cloud_speed * delta
