extends Camera2D

var target


func _physics_process(_delta):
	position = target.position

