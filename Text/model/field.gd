const Unit = preload("res://model/unit.gd")
const Intelligence = preload("res://model/intelligence.gd")
var view
var player
var ai
var units = []
var turn = -1


func _init(p):
	view = p
	ai = Intelligence.new(self)
	player = introduce(0)
	player.target = introduce(1)
	view.set_player(player)


func introduce(team):
	var unit = Unit.new("person")
	view.introduce(team, unit)
	units.append(unit)
	unit.team = team
	if team == 1:
		unit.target = player
	else:
		for i in units:
			if i.team == 1:
				unit.target = i
				break
	return unit


func next_turn():
	units[turn].discard_hand()
	turn = wrapi(turn - 1, -1, units.size())
	var unit = units[turn]
	_on_turn_start(unit)
	if turn > 0:
		do_enemy_turn(unit)


func next_round():
	for unit in units:
		unit.played.clear()


func do_enemy_turn(unit):
	var played_card = ai.play(unit)
	if played_card == null:
		view.end_turn()
	else:
		view.update()
		await view.get_tree().create_timer(0.5).timeout
		do_enemy_turn(unit)


func _on_turn_start(unit):
	unit.breath = min(unit.data.breath, unit.breath + 1)
	if unit.is_exhausted():
		unit.shuffle()

