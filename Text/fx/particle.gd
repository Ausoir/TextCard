extends GPUParticles2D

@export var expire = 1.0


func _ready():
	set_emitting(true)


func _process(delta):
	expire -= delta
	if expire <= 0:
		queue_free()
