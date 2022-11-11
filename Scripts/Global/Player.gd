extends Node # Herda tudo de Node
# Variáveis dos nodes filhos
onready var shoot_timer = $ShootTimer
onready var slide_timer = $SlideTimer
onready var hit_timer = $HitTimer
onready var death_timer = $DeathTimer
# Variáveis do tipo Inteiro
var level : int = 1
var lives : int = 3
var health : int = 4
var bullet_count : int = 0
var total_life : int = 3
var current_life : int
var current_xp : int
var total_xp : int
var power : int
# Variáveis do tipo Float
var xp_calculate : float = 1.3
# Variáveis do tipo Boolean
var is_alive : bool = true
var is_shooting : bool = false
var is_sliding : bool = false
var hitted : bool = false


func _on_ShootTimer_timeout():
	is_shooting = false


func _on_SlideTimer_timeout():
	is_sliding = false


func _on_HitTimer_timeout():
	hitted = false




func _on_DeathTimer_timeout():
	is_alive = true
