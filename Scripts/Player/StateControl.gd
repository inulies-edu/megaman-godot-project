extends PlayerBase

class_name PlayerState

enum StateMachine {IDLE, RUN, JUMP, FALL, SLIDE, HIT, DEATH}

var state = StateMachine.IDLE

func _enter_state(new_state) -> void:
	if state != new_state:
		state = new_state

func _check_idle_state() -> void:
	if is_on_floor() and direction != 0 and velocity.x != 0 and not player.is_sliding:
		_enter_state(StateMachine.RUN)
	elif not is_on_floor() and velocity.y < 0:
		_enter_state(StateMachine.JUMP)
	elif not is_on_floor() and velocity.y > 0:
		_enter_state(StateMachine.FALL)
	elif player.is_sliding:
		_enter_state(StateMachine.SLIDE)
	elif player.hitted:
		_enter_state(StateMachine.HIT)
	elif not player.is_alive:
		_enter_state(StateMachine.DEATH)
	

func _check_run_state() -> void:
	if is_on_floor() and direction == 0 and velocity.x == 0 and not player.is_sliding:
		_enter_state(StateMachine.IDLE)
	elif not is_on_floor() and velocity.y < 0:
		_enter_state(StateMachine.JUMP)
	elif not is_on_floor() and velocity.y > 0:
		_enter_state(StateMachine.FALL)
	elif player.is_sliding:
		_enter_state(StateMachine.SLIDE)
	elif player.hitted:
		_enter_state(StateMachine.HIT)
	elif not player.is_alive:
		_enter_state(StateMachine.DEATH)

func _check_fall_state() -> void:
	if is_on_floor() and velocity.x == 0 and not player.is_sliding:
		_enter_state(StateMachine.IDLE)
	elif is_on_floor() and direction != 0 and velocity.x != 0 and not player.is_sliding:
		_enter_state(StateMachine.RUN)
	elif not is_on_floor() and velocity.y < 0:
		_enter_state(StateMachine.JUMP)
	elif player.hitted:
		_enter_state(StateMachine.HIT)
	elif player.is_sliding:
		_enter_state(StateMachine.SLIDE)
	elif not player.is_alive:
		_enter_state(StateMachine.DEATH)

func _check_jump_state() -> void:
	if is_on_floor() and direction == 0 and velocity.x == 0:
		_enter_state(StateMachine.IDLE)
	elif not is_on_floor() and velocity.y > 0:
		_enter_state(StateMachine.FALL)
	elif player.hitted:
		_enter_state(StateMachine.HIT)
	elif player.is_sliding:
		_enter_state(StateMachine.SLIDE)
	elif not player.is_alive:
		_enter_state(StateMachine.DEATH)

func _check_slide_state() -> void:
	if not player.is_sliding:
		_enter_state(StateMachine.IDLE)
	elif player.hitted:
		_enter_state(StateMachine.HIT)
	elif is_on_floor() and Input.is_action_just_pressed("jump"):
		_enter_state(StateMachine.JUMP)
	elif not player.is_alive:
		_enter_state(StateMachine.DEATH)

func _check_hit_state() -> void:
	if not player.hitted:
		_enter_state(StateMachine.IDLE)
	elif not player.is_alive:
		_enter_state(StateMachine.DEATH)
