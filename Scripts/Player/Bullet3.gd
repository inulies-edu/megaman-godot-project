extends KinematicBody2D

class_name Bullet

export var speed = 360
export (int, "left", "right") var direction = 1
var bullet_dir = -1
var collision = true

func _ready():
	$AnimatedSprite.play("default")

func set_direction(dir):
	self.direction = dir

func _physics_process(delta):
	if direction == 0:
		$AnimatedSprite.flip_h = true
		bullet_dir = -1
	else:
		$AnimatedSprite.flip_h = false
		bullet_dir = 1
		
	var velocity = move_and_collide(Vector2(bullet_dir, 0) * speed * delta)
	
	
func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "hit":
		self.queue_free()

func _on_Area2D_area_entered(area):
	pass
		


func _on_Area2D_body_entered(body):
	speed = 0
	$AnimatedSprite.play("hit")
	$Area2D/CollisionShape2D.disabled = true
