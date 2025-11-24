extends Node

# autoloaded as BuilidngProgress
var ability_scene = preload("res://gathering/abilities/ability.tscn")


func instantiate_ability_with_script(script: String):
	var ability = ability_scene.instantiate()
	ability.set_script(load(script))
	return ability


func get_abilities():
	return [
		instantiate_ability_with_script("res://gathering/abilities/pick.gd"),
		instantiate_ability_with_script("res://gathering/abilities/saw.gd"),
	]
