extends KinematicBody2D

var base = preload('res://Animation/Player/Normal/Base.tres')
#var shieldArmor = preload('res://Animation/Player/Normal/ShieldArmor.tres')
var shoot = preload('res://Animation/Player/Shoot/Base.tres')
#var armorShoot = preload('res://Animation/Player/Shoot/ShieldArmor.tres')

export(NodePath) onready var Player = get_node(".")
onready var sfx = get_node("Sfx")
onready var body_collision = get_node("BodyColision")
onready var feet_collision = get_node("FeetCollision")
onready var colision = get_node("areatest/CollisionShape2D")
onready var dash_collision = get_node("DashCollision")
onready var changer = get_parent().get_node("Transition_in")
onready var hud = get_node("HUD")

export(float) var acceleration
export(float) var friction
var is_running = false


var velocity = Vector2()
var current_scene : String 
var unique = false
var bullet_count : int = 0
var speed : int  = 150
var speed_max : int = 150
var dash : int = 300
var direction : int = 1
var gravity : float = 10.0
var jump_force : int = 300
var hero_direction = 1
var dash_t : float = 0
var is_dashing : bool = false
var ended : bool = false
var can_play : bool = false
var hitted : bool = false
var is_alive = true
var is_charging = false
var live : bool = true
var super_charge = false
var medium_charge = false
var AstroCrush : bool = false
var modo = "normal"
var s = ""
var life : int = 4
var hurt : bool = false
var cutscene : bool = false
var only_once : bool = true


func _physics_process(delta) -> void:
	player.position = self.position
	if can_play == true:
		if player.mode == 0 and unique == false:
			unique = true
		elif player.mode == 1 and unique == false:
			#animation.normal_sprite.set_sprite_frames(shieldArmor)
			#animation.shoot_sprite.set_sprite_frames(armorShoot)
			unique = true
		if is_alive == true and ended == false:
			if !is_on_floor():
				only_once = false
			if is_on_floor() and only_once == false:
				only_once = true
				PlayerSfx.land.play()
			if hitted == false:
				if is_dashing == false:
					_apply_gravity()
					animation._animate()
					_move_behavior()
					_input_player(delta)
					_jump()
					_move_and_slide()
					_can_die()
					_hurt_mode()
				else:
					_apply_gravity()
					animation._animate()
					_input_player(delta)
					_move_and_slide()
					_can_die()
					hitted = false
					if !is_on_floor():
						is_dashing = false
					hitted = false
					
			else:
				_apply_gravity()
				_knockback()
				animation._animate()
				_move_and_slide()
				_can_die()
				is_dashing = false
				AstroCrush = false
				super_charge = false
				_input_player(delta)
				s = ""
			
		elif is_alive == false and ended == false:
			animation._animate()
			_can_die()
			PlayerSfx.die.play()
			ended = true
			
	else:
		animation._animate()
		_move_and_slide()
		velocity.y = 400
		if is_on_floor():
			velocity.y = 0
		if animation.normal_sprite.frame == 11:
			can_play = true
			
		


func _input_player(delta):
	if Input.is_action_just_pressed("shoot"): #Animação de tiro e o tempo que a animação de tiro ficará ativa
		$ChargeTimer.start()
		if hitted == false:
			if is_dashing == false:
				if is_charging == false and bullet_count < 3:
					$ShootTimer.start()
					player._shoot(is_on_floor(), hero_direction, animation.normal_sprite.flip_h)
					s = "s"
						
		
	if Input.is_action_just_pressed("dash") and is_on_floor() and is_dashing == false and hitted == false:
		is_dashing = true
		_dash(delta)
		PlayerSfx.slide.play()
		body_collision.disabled = true
		dash_collision.disabled = false
		
	if Input.is_action_just_released("shoot"):
		if is_dashing == false:
			if medium_charge == false:
				if is_charging == true:
					$ShootTimer.start()
					$ChargeTimer.stop()
					$Charged1.stop()
					s = "s"
					self._shoot2()
					is_charging = false
					super_charge = false
					medium_charge = false
					PlayerSfx.charge.stop()
					
				else:
					$ChargeTimer.stop()
					$Charged1.stop()
					is_charging = false
					super_charge = false
					medium_charge = false
					PlayerSfx.charge.stop()
					
			else:
				$ShootTimer.start()
				$ChargeTimer.stop()
				$Charged1.stop()
				s = "s"
				self._shoot3(hero_direction)
				is_charging = false
				super_charge = false
				medium_charge = false
				PlayerSfx.charge.stop()
				
		else:
			is_charging = false
			medium_charge = false
			super_charge = false
			PlayerSfx.charge.stop()
			$ChargeTimer.stop()
			$Charged1.stop()

func _apply_gravity() -> void:
	velocity.y += gravity

func _jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
		PlayerSfx.jump.play()
		

func _move_behavior() -> void:
	var vx = -int(Input.is_action_pressed("ui_left")) +  int(Input.is_action_pressed("ui_right"))
	velocity.x = lerp(velocity.x, vx * speed, .1)
	if vx == 0 and is_on_floor():
		velocity.x = 0
	if vx != 0:
		direction = vx
	
func _knockback() -> void:
	velocity.x = 0
	colision.disabled = true
	if animation.normal_sprite.animation == "Hit" and animation.normal_sprite.flip_h:
		velocity.x += 70
	elif animation.normal_sprite.animation == 'Hit' and animation.normal_sprite.flip_h == false:
		velocity.x -= 70

func _shoot():
	var pre_bullet = preload("res://Scenes/Player/Bullet.tscn")
	var bullet = pre_bullet.instance()
	var bullet_effect = preload("res://Scenes/Player/shooteffect.tscn")
	var effect = bullet_effect.instance()
	bullet.set_direction(hero_direction)
	if is_on_floor():
		bullet.position.y = self.position.y + 0.9
		effect.position.y = self.position.y + 2.3
	else:
		bullet.position.y = self.position.y - 0.6
		effect.position.y = self.position.y + 2.3
	if animation.normal_sprite.flip_h == true:
		bullet.position.x = self.position.x -25
		effect.position.x = self.position.x -27
		effect.flip_h = true
	else:
		bullet.position.x = self.position.x + 25
		effect.position.x = self.position.x + 27
	get_parent().add_child(bullet)
	get_parent().add_child(effect)
	PlayerSfx.shoot1.play()
	bullet_count += 1

func _shoot2():
	var pre_bullet = preload("res://Scenes/Player/Bullet2.tscn")
	var bullet = pre_bullet.instance()
	var bullet_effect = preload("res://Scenes/Player/shooteffect2.tscn")
	var effect = bullet_effect.instance()
	bullet.set_direction(hero_direction)
	if is_on_floor():
		bullet.position.y = self.position.y + 2
		effect.position.y = self.position.y + 2
	else:
		bullet.position.y = self.position.y + 2
		effect.position.y = self.position.y + 2
	if animation.normal_sprite.flip_h == true:
		bullet.position.x = self.position.x -32
		effect.position.x = self.position.x -32
		effect.flip_h = true
	else:
		bullet.position.x = self.position.x + 27
		effect.position.x = self.position.x + 27
	get_parent().add_child(bullet)
	get_parent().add_child(effect)
	PlayerSfx.shoot2.play()

func _shoot3(direction):
	var pre_bullet = preload("res://Scenes/Player/Bullet3.tscn")
	var bullet = pre_bullet.instance()
	var bullet_effect = preload("res://Scenes/Player/shooteffect3.tscn")
	var effect = bullet_effect.instance()
	bullet.set_direction(direction)
	if is_on_floor():
		bullet.position.y = self.position.y + 1
		effect.position.y = self.position.y + 3
	else:
		bullet.position.y = self.position.y 
		effect.position.y = self.position.y 
	if animation.normal_sprite.flip_h == true:
		bullet.position.x = self.position.x -32
		effect.position.x = self.position.x -32
		effect.flip_h = true
	else:
		bullet.position.x = self.position.x + 32
		effect.position.x = self.position.x + 32
	get_parent().add_child(bullet)
	get_parent().add_child(effect)
	PlayerSfx.shoot3.play()

func _can_die() -> void:
	if life < 1:
		is_alive = false
		


func _dash(delta):
	if is_dashing == true and animation.normal_sprite.flip_h == false and velocity.x != 0:
		velocity.x += speed
	elif is_dashing == true and animation.normal_sprite.flip_h == true and velocity.x != 0:
		velocity.x -= speed
	elif is_dashing == true and animation.normal_sprite.flip_h == false and velocity.x == 0:
		velocity.x += dash
	elif is_dashing == true and animation.normal_sprite.flip_h == true and velocity.x == 0:
		velocity.x -= dash

func _move_and_slide():
	velocity = move_and_slide(velocity, Vector2.UP, true)
func  _hurt_mode():
	if life <= 2:
		hurt = true
	else:
		hurt = false
	
##### Node Functions #####

func _on_ShootTimer_timeout():
	s = ""

func _on_areatest_area_entered(area):
	if area.is_in_group('Enemies') and ended == false:
		player.health -= 1
		hitted = true
		PlayerSfx.hit.play()

func _on_NormalSprite_animation_finished():
	if animation.normal_sprite.animation == 'Dash':
		is_dashing = false
		body_collision.disabled = false
		dash_collision.disabled = true
	elif animation.normal_sprite.animation == 'Hit':
		hitted = false
		colision.disabled = false
	elif animation.normal_sprite.animation == "Die":
		animation.visible = false
		player._die()

func _on_ChargeTimer_timeout():
	is_charging = true
	$Charged1.start()
	PlayerSfx.charge.play()



func _on_ShootSprite_animation_finished():
	if animation.shoot_sprite.animation == 'Hurt':
		super_charge = false
		is_charging = false
		animation.hurt = false
		s = ""

func _on_Charged1_timeout():
	is_charging = false
	medium_charge = true


func _on_VisibilityNotifier2D_screen_entered():
	if can_play == false:
		yield(get_tree().create_timer(0.1), 'timeout')
		PlayerSfx.intro.play()
