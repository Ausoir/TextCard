extends Control

const Settings = preload("res://menu/settings.tscn")

var menu
var menu_callback


func set_color(color):
	$Canvas/Bg.set_color(color)


func fade(color, time):
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property($Canvas/Bg, "color", color, time)


func clear_menu():
	if menu != null:
		if menu_callback != null:
			menu_callback.call()
		var parent = menu.get_parent()
		if parent == $Canvas:
			$Canvas.remove_child(menu)
		elif parent == self:
			remove_child(menu)
		if menu != null:
			var tween = get_tree().create_tween()
			tween.tween_property($Canvas/Bg, "color", Color.TRANSPARENT, 2)
			tween.set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_ELASTIC)
			tween.set_parallel(true)
			tween.tween_property(menu, "scale", Vector2.ZERO, .7)
			tween.tween_callback(menu.queue_free)
		menu = null
		$Canvas/Return.undisplay()


func show_menu(p, params=null, cb=null):
	clear_menu()
	menu = p.instantiate()
	menu.set("params", params)
	menu.scale = Vector2.ZERO
	$Canvas.add_child(menu)
	$Canvas.move_child(menu, 1)
	var tween = get_tree().create_tween()
	tween.tween_property($Canvas/Bg, "color", Color(0,0,0, 0.5), 2)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_parallel(true)
	tween.tween_property(menu, "scale", Vector2.ONE, .7)
	$Canvas/Return.display()
	menu_callback = cb


func _on_return_pressed():
	clear_menu()


func update_clock(time):
	var minutes = int(time) % 60
	var hours = int(time / 60.0) % 24
	var suffix = "AM"
	if hours > 11:
		suffix = "PM"
	hours = hours % 12
	if hours == 0:
		hours = 12
	var hhmm = "%2d:%02d %s" % [hours, minutes, suffix]
	$Canvas/Panel/Stamina/Time.set_text(hhmm)

