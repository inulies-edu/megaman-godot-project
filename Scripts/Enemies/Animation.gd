extends AnimatedSprite

export(NodePath) onready var enemy = get_node("..") as KinematicBody2D

func _animate(velocity : Vector2) -> void:
	if enemy.can_attack or enemy.can_hit or enemy.can_die:
		_action_behavior()
	else:
		_move_behavior(velocity)


func _action_behavior() -> void:
	if enemy.can_die:
		enemy.animation.play('dead')
		enemy.can_hit = false
		enemy.can_attack = false
		enemy.can_move = false
	if enemy.can_hit:
		enemy.animation.play('hit')
		enemy.can_attack = false
		enemy.can_move = false
	elif enemy.can_attack:
		enemy.animation.play('attack')
		enemy.can_move = false
		

func _move_behavior(velocity : Vector2) -> void:
	if enemy.velocity.x != 0:
		enemy.animation.play('walk')
	else:
		enemy.animation.play('idle')



		
