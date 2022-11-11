extends KinematicBody2D

class_name Bullet2

export var speed : int = 340
var direction : int = 1
var velocity = Vector2()
var collision : bool = true

func _ready():
	$AnimatedSprite.play("default")

func set_direction(dir):
	self.direction = dir

func _physics_process(delta):
	velocity.x = speed * direction
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if $AnimatedSprite.animation == 'hit':
		$Area2D/CollisionShape2D.disabled = true


func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()
	player.bullet_count -= 1


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "hit":
		self.queue_free()

func _on_Area2D_area_entered(area):
	if area.is_in_group('Enemies'):
		speed = 0
		$AnimatedSprite.play('hit')


func _on_Area2D_body_entered(body):
	speed = 0
	$AnimatedSprite.play('hit')
