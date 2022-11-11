extends Control


func _ready():
	$AnimatedSprite.play("default")


func _on_AnimatedSprite_animation_finished():
	TransitionScreen.fade_in('res://Scenes/Intro/Godot.tscn')
