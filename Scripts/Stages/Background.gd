extends ParallaxBackground

export(Array, int) var layer_speed #velocidade_camada
export(bool) var can_move_layer #Pode_mover_camadas?


func _physics_process(delta: float) -> void: #1/60 = 0.0016667
	if can_move_layer:
		var index: int = 0
		for parallax_layer in get_children():
			parallax_layer.motion_offset.x -= layer_speed[index] * delta
			index += 1
			
		index = 0
