extends Control

export var move_to_scene : PackedScene

onready var transition = TransitionScreen
onready var logo = $Logo
onready var shader_time = logo.material.get_shader_param('shine_speed')
var one_once = false

func _ready():
	logo.animation = 'default'
	logo.frame = 0
	yield(get_tree().create_timer(1.5), "timeout")
	logo.play("default")





func _on_Logo_animation_finished():
	if logo.animation == "default":
		logo.play('pause')
		TransitionScreen.ready = false
		$Animation.play("shine")


func _on_Animation_animation_finished(anim_name):
	if anim_name == 'shine':
		$Animation.stop()
		TransitionScreen.scene_in(move_to_scene)
