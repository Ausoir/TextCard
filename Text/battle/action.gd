extends Button

var new


func play_place(newparent, toward):
	new = duplicate()
	newparent.add_child(new)
	new.global_position = global_position
	new.set_deferred("size", size)
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property(new, "global_position", global_position, 0)
	tween.tween_property(new, "global_position", toward, .2)
	tween.tween_callback(remove)
	new.set_disabled(true)


func remove():
	new.queue_free()
	new.get_parent().remove_child(new)

