var name: String
var states = []
var deck = []
var hand = [null, null, null, null]
var spent = []
var data
var played = []
var team = 0
var target
var energy: int = 0
var defense: int = 0
var breath: int = 0
var dodge: int = 0
var stun: int = 0
var view


func _init(p):
	name = p
	data = G.file.unit.get(p)
	if data != null:
		for key in data.keys():
			set(key, data[key])
	for skillname in data.skills:
		var skill = G.file.skill.get(skillname)
		deck.append(skill)
	shuffle()


func play(idx):
	var card = hand[idx]
	if breathe(card.get("cost", 1)):
		played.append(card)
		discard(idx)
		draw(idx)
		return card
	return null


func apply_damage(dmg):
	var passed = defense - dmg
	defense = max(0, passed)
	energy += passed


func apply_properties(properties):
	for key in properties.keys():
		if key == "damage":
			apply_damage(properties[key])
		else:
			var val = get(key)
			if val != null:
				set(key, val + properties[key])


func apply_card(card):
	var buff = card.get("self")
	if buff != null:
		apply_properties(buff)
	var inflict = card.get("inflict")
	if inflict != null:
		target.apply_properties(inflict)


func apply_next_card():
	var card = played.pop_front()
	apply_card(card)


func draw(idx):
	var card = deck.pop_front()
	hand[idx] = card


func discard(idx):
	var held = hand[idx]
	if held != null:
		spent.append(held)
		hand[idx] = null


func discard_hand():
	for i in range(4):
		discard(i)


func breathe(p):
	if breath >= p:
		breath -= p
		return true
	return false


func shuffle():
	for i in range(4):
		discard(i)
	deck += spent
	spent.clear()
	deck.shuffle()
	for i in range(4):
		draw(i)


func is_exhausted():
	for i in hand:
		if i != null:
			return false
	return true
