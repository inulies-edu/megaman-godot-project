extends Area2D



export(NodePath) onready var enemy = get_node("..") as KinematicBody2D

func _on_DetectionArea_body_entered(body: Player):
	enemy.player_ref = body


func _on_DetectionArea_body_exited(body: Player):
	enemy.player_ref = null
