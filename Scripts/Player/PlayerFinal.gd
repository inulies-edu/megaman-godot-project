extends PlayerState

class_name Player

var animation_Base = preload('res://Animation/Player/Normal/Base.tres')
var animation_SupAdaptB = preload('res://Animation/Player/Normal/SuperAdaptorBlue.tres')
var animation_SupAdaptR = preload('res://Animation/Player/Normal/SuperAdaptorRed.tres')
var animation_BaseShoot = preload('res://Animation/Player/Shoot/Base.tres')
var animation_SupAdaptBShoot = preload('res://Animation/Player/Shoot/SuperAdaptorBlue.tres')
var animation_SupAdaptRShoot = preload('res://Animation/Player/Shoot/SuperAdaptorRed.tres')


func _ready():
	player.is_alive = true
	player.current_life = player.total_life
	state = StateMachine.IDLE
	animation_sprite.normal.set_sprite_frames(animation_Base)
	animation_sprite.shoot.set_sprite_frames(animation_BaseShoot)

func _physics_process(delta):
	match state:
		StateMachine.IDLE : _idle_state()
		StateMachine.RUN : _run_state()
		StateMachine.JUMP : _jump_state()
		StateMachine.FALL : _fall_state()
		StateMachine.SLIDE : _slide_state()
		StateMachine.HIT : _hit_state()
		StateMachine.DEATH : _death_state()
		





func _idle_state() -> void:
	_animate('Idle')
	_shoot()
	_move_behavior()
	_jump()
	_slide()
	_can_die()
	_apply_gravity()
	_move_and_slide()
	_check_idle_state()
	

func _run_state() -> void:
	_animate('Run')
	_move_behavior()
	_flip()
	_jump()
	_shoot()
	_slide()
	_can_die()
	_apply_gravity()
	_move_and_slide()
	_check_run_state()

func _fall_state() -> void:
	_animate('Fall')
	_move_behavior()
	_flip()
	_shoot()
	_air_dash()
	_can_die()
	_apply_gravity()
	_move_and_slide()
	_check_fall_state()

func _jump_state() -> void:
	_animate('Jump')
	_move_behavior()
	_flip()
	_shoot()
	_can_die()
	_air_dash()
	_apply_gravity()
	_move_and_slide()
	_check_jump_state()

func _slide_state() -> void:
	_animate('Slide')
	_slide_movement(view_direction)
	_jump()
	_can_die()
	_dash_gravity()
	_move_and_slide()
	_check_slide_state()

func _hit_state() -> void:
	_animate('Hit')
	_knockback()
	_can_die()
	_apply_gravity()
	_move_and_slide()
	_check_hit_state()

func _death_state() -> void:
	_animate('Die')
	_death()











func _on_Hitbox_area_entered(area):
	if area.is_in_group('Enemies'):
		player.hitted = true
		animation_sprite.hit.play('Hit', -1, 0.09, false)
		player.hit_timer.start()
		PlayerSfx.hit.play()
	elif area.is_in_group('RushAdaptor'):
		animation_sprite.transform_animation.play('Red')
		animation_sprite.normal.set_sprite_frames(animation_SupAdaptR)
		animation_sprite.shoot.set_sprite_frames(animation_SupAdaptRShoot)
		transformed = true
	elif area.is_in_group('BeatAdaptor'):
		animation_sprite.transform_animation.play('Blue')
		animation_sprite.normal.set_sprite_frames(animation_SupAdaptB)
		animation_sprite.shoot.set_sprite_frames(animation_SupAdaptBShoot)
		transformed = true


func _on_Hit_animation_finished(anim_name):
	if anim_name == 'Hit':
		hitbox.disabled = false





func _on_Transform_animation_finished():
	if animation_sprite.transform_animation.animation == 'Base' or 'Blue' or 'Red':
		animation_sprite.transform_animation.play('default')
