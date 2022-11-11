extends KinematicBody2D

onready var gotHitted = get_node("Hitbox/Collision")

func _ready() -> void:
	$Animation.play('Idle')
	$HitAnimation.play('Idle')

func _physics_process(delta) -> void:
	hitted()
	animate()
	

func hitted() -> void:
	
	if gotHitted.disabled == true:
		$Hitbox.monitorable = false
		$Hitbox.monitoring = false
	else:
		$Hitbox.monitorable = true
		$Hitbox.monitoring = true

func animate() -> void:
	if gotHitted.disabled == true:
		$Animation.visible = false
		$HitAnimation.visible = true
		
	else:
		$Animation.visible = true
		$HitAnimation.visible = false
func _on_Hitbox_area_entered(area):
	if area.is_in_group('Bullet'):
		$Hitbox/Collision.disabled = true
		$HitTimer.start()
		print('hitted')

func _on_HitTimer_timeout():
	gotHitted.disabled = false

