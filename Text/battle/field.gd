extends VBoxContainer

const Field = preload("res://model/field.gd")
const Unit = preload("res://battle/unit.tscn")
const Action = preload("res://battle/action.tscn")
var targetable_group: ButtonGroup
var id = 0
var player
var units = []
var model


func _ready():
	targetable_group = ButtonGroup.new()
	model = Field.new(self)
	for unit in $Targets.get_children():
		if unit.model == player.target:
			unit.get_node("Top/Button").set_pressed(true)
	end_turn()


func set_player(p):
	player = p


func introduce(team, unitmodel):
	var unit = Unit.instantiate()
	unit.set_unit(unitmodel)
	unit.set_group(targetable_group)
	if team == 0:
		units.append(unit)
		$Allies.add_child(unit)
	else:
		units.append(unit)
		$Targets.add_child(unit)
	unit.update()
	return unit


func update_hand(idx):
	var card = player.hand[idx]
	var node = $Player/VBox/Action.get_child(idx)
	if card == null:
		node.set_text(" ")
		node.set_disabled(true)
	else:
		node.set_text(card.name)
		node.set_disabled(false)


func update():
	for i in range(4):
		update_hand(i)
	units[wrapi(model.turn - 1, 0, units.size())].shine(false)
	units[model.turn].shine(true)
	if model.turn == 0:
		$Player/VBox.show()
		$Player/VBox/Header/Breath.modulate = Color.WHITE
		$Player.modulate = Color.WHITE
	else:
		$Player/VBox.hide()
		$Player/VBox/Header/Breath.modulate = Color.RED
		$Player.modulate = Color.DIM_GRAY
	$Player/VBox/Header/Breath.set_text(str(player.breath, "/", player.data.breath))
	for child in $Allies.get_children() + $Targets.get_children():
		child.update()
		for i in child.bottom.get_children():
			i.queue_free()
			child.bottom.remove_child(i)
		for i in child.model.played:
			var card = Action.instantiate()
			card.set_text(i.name)
			card.set_disabled(true)
			child.bottom.add_child(card)


func end_turn():
	model.next_turn()
	update()
	if model.turn == -1:
		fight()


func fight():
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	for child in $Allies.get_children():
		child.fight(tween, -1)
	for child in $Targets.get_children():
		child.fight(tween, 1)
	tween.tween_callback(model.next_round)
	tween.tween_callback(end_turn)


func _on_action_pressed(idx):
	if player.play(idx):
		var node = $Player/VBox/Action.get_child(idx)
		node.play_place(UI, player.view.bottom.global_position)
		update()


func _on_wait_pressed():
	if model.turn == 0:
		end_turn()

