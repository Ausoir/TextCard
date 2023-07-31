extends Node

var _frame = 0
var events = []
var debt = 0


func process(delta):
	_frame += delta
	if _frame > 0.25:
		_frame -= 0.25
		for i in events:
			i.call()
