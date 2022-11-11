extends Node2D

onready var bgsnd = get_node("BackgroundSound")
onready var player = get_node("Rockman")

func _ready():
	pass

func _physics_process(delta):
	bgsnd.global_position = player.global_position


