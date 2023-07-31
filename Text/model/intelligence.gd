var field


func _init(p):
	field = p


func play(unit):
	var hand = []
	for i in range(4):
		if unit.hand[i] != null:
			hand.append(i)
	if hand.size() == 0:
		return null
	hand.shuffle()
	var r = unit.play(hand.pop_front())
	return r

