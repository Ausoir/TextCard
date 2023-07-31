extends Node

const P_marker = preload("res://fx/marker.tscn")
const P_fire = preload("res://fx/fire.tscn")


func make_particle(pos, particle):
	var scene = get(str("P_", particle))
	if scene != null:
		var r = scene.instantiate()
		r.position = pos
		add_child(r)
		return r
	else:
		print("Could not make particle ", particle)
