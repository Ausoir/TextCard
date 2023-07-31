extends VBoxContainer

const STR_ENERGY = "res://asset/icon/energy.svg"
const STR_ATTACK = "res://asset/icon/attack.svg"
const STR_DEFENSE = "res://asset/icon/defense.svg"
const STR_DODGE = "res://asset/icon/dodge.svg"
const Shine = preload("res://asset/shader/shine.tres")
var model
@onready var bottom = $Bottom


func set_unit(p):
	model = p
	model.view = self


func shine(p):
	if p:
		$Top/Button.set_material(Shine)
	else:
		$Top/Button.set_material(null)


func set_group(group):
	$Top/Button.set_button_group(group)


func fight(tween: Tween, dir):
	for skill in bottom.get_children():
		var skilldata = G.file.skill.get(skill.text)
		if "inflict" in skilldata:
			tween.tween_property($Top/Button, "global_position", global_position + Vector2(0, 64*dir), 0.15)
			tween.tween_property($Top/Button, "global_position", global_position, 0.8)
			tween.set_parallel(true)
			tween.tween_property($Top/Button, "rotation", 0.24*dir, 0.1)
		else:
			tween.tween_property($Top/Button, "global_position", global_position + Vector2(32, 0), 0.4)
			tween.tween_property($Top/Button, "global_position", global_position, 0.4)
			tween.set_parallel(true)
		tween.tween_property(skill, "scale", Vector2(0, 1), 0.3)
		tween.tween_property(skill, "modulate", Color.TRANSPARENT, 0.3)
		tween.tween_property($Top/Button, "rotation", 0, 0.4)
		tween.set_parallel(false)
		tween.tween_callback(model.apply_next_card)
		tween.set_parallel(true)
		tween.tween_callback(pop_skill.bind(skill))
		tween.tween_callback(update)
		tween.tween_callback(model.target.view.update)
		tween.set_parallel(false)


func pop_skill(child):
	child.queue_free()
	bottom.remove_child(child)


func update():
	$Top/Text.clear()
	_add_icon(STR_ENERGY, model.energy)
	_add_icon(STR_DODGE)
	_add_icon(STR_DEFENSE, model.defense)
	$Top/Text.append_text("\n")
	for skilldata in model.played:
		var buff = skilldata.get("self")
		if buff != null:
			var defense = buff.get("defense", 0)
			_add_icon(STR_DEFENSE, defense)
		var inflict = skilldata.get("inflict")
		if inflict != null:
			var attack = inflict.get("damage", 0)
			_add_icon(STR_ATTACK, attack)


func _add_icon(path, suffix=-1, default=0):
	if suffix != default:
		if suffix == -1:
			suffix = ""
		var r = str("[img=32x32]", path, "[/img]", suffix, " ")
		$Top/Text.append_text(r)

