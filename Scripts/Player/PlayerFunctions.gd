extends KinematicBody2D

class_name PlayerBase



onready var animation_sprite = get_node('Animation')
onready var base_collision = get_node('BaseCollision')
onready var dash_collision = get_node('DashCollision')
onready var hitbox = get_node('Hitbox/Collision')

const speed : int  = 150
const jump_force : int = 300

var velocity = Vector2()

var dash_count : int = 0
var direction : int = 0
var bullet_count : int = 0
var view_direction : int = 0

var gravity : float = 9.0

var animation : String = 'N/A'

var shoot : bool = false
var transformed : bool = false


func _process(delta):
	pass

func _apply_gravity() -> void:
	velocity.y += gravity


func _move_and_slide():
	velocity = move_and_slide(velocity, Vector2.UP)


func _move_behavior() -> void:
	direction = Input.get_axis("move_left", 'move_right')
	velocity.x = lerp(velocity.x, direction * speed, .1)
	if direction == 0 and is_on_floor():
		velocity.x = 0


func _jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
		PlayerSfx.jump.play()
		player.is_sliding = false

func _flip() -> void:
	if direction > 0:
		animation_sprite.normal.flip_h = false
		animation_sprite.shoot.flip_h = false
	elif direction < 0:
		animation_sprite.normal.flip_h = true
		animation_sprite.shoot.flip_h = true
	if animation_sprite.normal.flip_h == false:
		view_direction = 1
	else:
		view_direction = -1
	

func _shoot() -> void:
	if Input.is_action_just_pressed("shoot"):
		if player.bullet_count < 3:
			player.is_shooting = true
			player.shoot_timer.start()
			_normal_shoot1()

func _slide() -> void:
	if Input.is_action_just_pressed("dash"):
		player.is_sliding = true
		player.slide_timer.start()
		PlayerSfx.slide.play()
	if is_on_floor():
		dash_count = 0
	

func _slide_movement(set_direction) -> void:
	velocity.x = lerp(velocity.x, set_direction * 300, .5)
	
		

func _animate(animation_name : String) -> void:
	if animation != animation_name:
		animation = animation_name
		animation_sprite.normal.play(animation)
		animation_sprite.shoot.play(animation)
	if player.is_shooting:
		animation_sprite.normal.visible = false
		animation_sprite.shoot.visible = true
	else:
		animation_sprite.normal.visible = true
		animation_sprite.shoot.visible = false

func _can_die() -> void:
	if player.current_life <= 0:
		player.is_alive = false

func _death() -> void:
	hitbox.disabled = true
	animation_sprite.dead_effect.emitting = true
	player.death_timer.start()
	yield(get_tree().create_timer(3.0), "timeout")
	TransitionScreen.reset_in()

func _dash_gravity() -> void:
	if is_on_floor():
		_apply_gravity()
	else:
		velocity.y = 0

func _air_dash() -> void:
	print(dash_count)
	if transformed and dash_count == 0:
		if Input.is_action_just_pressed("dash"):
			player.is_sliding = true
			player.slide_timer.start()
			PlayerSfx.slide.play()
			dash_count = 1
	if is_on_floor():
		dash_count = 0
	
	

func _knockback() -> void:
	velocity.x = 0
	hitbox.disabled = true
	if player.hitted and animation_sprite.normal.flip_h:
		velocity.x += 70
	elif player.hitted and animation_sprite.normal.flip_h == false:
		velocity.x -= 70

func _normal_shoot1():
	var pre_bullet = preload("res://Scenes/Player/Bullet.tscn")
	var bullet = pre_bullet.instance()
	var bullet_effect = preload("res://Scenes/Player/shooteffect.tscn")
	var effect = bullet_effect.instance()
	bullet.set_direction(view_direction)
	if is_on_floor():
		bullet.position.y = self.position.y - 5.5
		effect.position.y = self.position.y - 4.5
	else:
		bullet.position.y = self.position.y - 7.5
		effect.position.y = self.position.y - 6.5
	if animation_sprite.normal.flip_h == true:
		bullet.position.x = self.position.x - 29
		effect.position.x = self.position.x - 31
		effect.flip_h = true
	else:
		bullet.position.x = self.position.x + 29
		effect.position.x = self.position.x + 31
	get_parent().add_child(bullet)
	get_parent().add_child(effect)
	PlayerSfx.shoot1.play()
	player.bullet_count = 0
	
