extends CanvasLayer


onready var animation = get_node("Animation")
var ready : bool = false

var target_level : PackedScene

func reset_in() -> void:
	animation.play("reset_in")

func scene_in(level : PackedScene) -> void:
	target_level = level
	animation.play("fade_in")

func _on_Animation_animation_finished(anim_name):
	if anim_name == "fade_in":
		get_tree().change_scene_to(target_level)
		animation.play("fade_out")
	elif anim_name == "reset_in":
		var change_level = get_tree().reload_current_scene()
		animation.play("fade_out")
	elif anim_name == "fade_out":
		ready = true
