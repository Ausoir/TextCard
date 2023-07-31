extends Node

var stock = preload("res://tool/stock.gd").new()
var time = preload("res://tool/time.gd").new()
var file = preload("res://tool/files.gd").new()
var world
var camera
var you
var vars


func _ready():
	set_process(false)


func start():
	vars = {}
	add_child(stock)
	add_child(time)
	set_process(true)
	UI.set_color(Color.BLACK)
	UI.fade(Color.TRANSPARENT, 1)


func _process(delta):
	time.process(delta)


func start_world():
	vars = file.Template.get_data()
	vars["seed"] = Time.get_unix_time_from_system()
	get_tree().change_scene_to_file("res://battle/field.tscn")


func load_world():
	vars = file.load_json("user://savegame.save")
	get_tree().change_scene_to_file("res://battle/field.tscn")


func _notification(what: int):
	match what:
		NOTIFICATION_WM_CLOSE_REQUEST:
			quit()


func quit():
	print("close")
	if vars != null: #game started
		file.save(vars)
	get_tree().quit()

