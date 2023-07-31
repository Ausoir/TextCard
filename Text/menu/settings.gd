extends VBoxContainer


func _ready():
	pass


func _on_delete_pressed():
	G.file.save("")


func _on_exit_pressed():
	G.quit()
