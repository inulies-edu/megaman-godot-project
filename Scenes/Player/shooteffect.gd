extends AnimatedSprite


func _ready():
	self.play("default")


#func _process(delta):
#	pass


func _on_shooteffect_animation_finished():
	if self.animation == "default":
		self.queue_free()
