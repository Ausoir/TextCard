extends TextureButton

var tween


func display():
	if tween != null:
		tween.stop()
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_parallel(true)
	tween.tween_property(self, "scale", Vector2.ONE, .7)


func undisplay():
	if tween != null:
		tween.stop()
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_parallel(true)
	tween.tween_property(self, "scale", Vector2.ZERO, .7)
