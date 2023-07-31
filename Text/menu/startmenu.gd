extends Control

var tween


func _ready():
	$GPUParticles2D.process_material.emission_box_extents = Vector3($Bg.size.x/2, $Bg.size.y/2, 1)
	$GPUParticles2D.position = Vector2($Bg.size.x/2, $Bg.size.y/2)
	if !G.file.is_valid("user://savegame.save"):
		_on_new_pressed.call_deferred()
	else:
		_on_load_pressed.call_deferred()


func _on_settings_pressed():
	if tween != null:
		tween.kill()
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property($HBox, "scale", Vector2.ZERO, 1)
	tween.tween_callback($HBox.hide)
	UI.show_menu(UI.Settings, null, _on_settings_hide)


func _on_settings_hide():
	if tween != null:
		tween.kill()
	$HBox.show()
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property($HBox, "scale", Vector2.ONE, 1)


func _on_new_pressed():
	queue_free()
	get_tree().get_root().remove_child(self)
	G.start()
	G.start_world()


func _on_load_pressed():
	queue_free()
	get_tree().get_root().remove_child(self)
	G.start()
	G.load_world()
