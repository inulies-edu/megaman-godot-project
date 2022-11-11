extends KinematicBody2D
class_name Enemy

signal kill

onready var animation = get_node("Animation")
onready var floor_cast = get_node("RayCast")
onready var detection_area = get_node("DetectionArea/CollisionShape2D")
onready var timer = get_node("Timer")
onready var hitbox = get_node("HitBox")

var can_die: bool = false
var can_hit: bool = false
var can_attack: bool = false
var can_move: bool = false
var can_shoot: bool = true

var velocity = Vector2()
var player_ref: Player = null
var hero_direction = 1
var gravity : float = 10.0
var speed : int  = 70
var proximity_threshold : int = 200
var life = 10

func _ready():
	can_move = true

func _physics_process(delta):
	if life <= 0:
		animation.play('dead')
		$HitBox/Collision.disabled = true
	else:
		_gravity(delta)
		_move_behavior()
		_verify_position()
		animation._animate(velocity)
		_shoot()
		velocity = move_and_slide(velocity, Vector2.UP)
		


func _move_behavior() -> void:
	if player_ref != null:
		var distance: Vector2 = player_ref.global_position - global_position
		var direction: Vector2 = distance.normalized()
		
		if abs(distance.x) <= proximity_threshold:
			velocity.x = 0
			can_attack = true
		elif _floor_collision() and not can_attack and can_move == true:
			velocity.x = direction.x * speed
			
		
	else:
		velocity.x = 0

func _gravity(delta : float) -> void:
	velocity.y += gravity

func _floor_collision():
	if floor_cast.is_colliding():
		return true
	return false



func _verify_position() -> void:
	if player_ref != null:
		var direction: float = sign(player_ref.global_position.x - global_position.x)
		if direction > 0:
			animation.flip_h = true
			
		elif direction < 0:
			animation.flip_h = false
			

func _shoot():
	hero_direction = 1 if animation.flip_h == true else 0
	if animation.animation == 'attack' and animation.frame == 7 and can_shoot == true:
		var pre_bullet = preload("res://Scenes/Enemies/EnemyBullet.tscn")
		var bullet = pre_bullet.instance()
		bullet.set_direction(hero_direction)
		if is_on_floor():
			bullet.position.y = self.position.y 
		else:
			bullet.position.y = self.position.y 
		if animation.flip_h == true:
			bullet.position.x = self.position.x + 10
			bullet.position.y = self.position.y + 7
		else:
			bullet.position.x = self.position.x - 10
			bullet.position.y = self.position.y + 7
		get_parent().add_child(bullet)
		can_shoot = false
		timer.start()



func _on_Animation_animation_finished():
	if animation.animation == "attack":
		can_attack = false
		can_move = true
		
	elif animation.animation == "hit":
		can_hit = false
		can_move = true
		
	
	elif animation.animation == "dead":
		queue_free()

func _on_Timer_timeout():
	can_shoot = true





func _on_HitBox_area_entered(area):
	if area.is_in_group('Player'):
		player.current_life -= 1
	elif area.is_in_group('Bullet2'):
		can_hit = true
		life -= 2
	elif area.is_in_group('Bullet'):
		can_hit = true
		life -= 1
	elif area.is_in_group('Bullet3'):
		can_hit = true
		life -= 4
