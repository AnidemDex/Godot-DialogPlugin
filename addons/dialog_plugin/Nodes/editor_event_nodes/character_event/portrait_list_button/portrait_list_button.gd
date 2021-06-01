tool
extends "res://addons/dialog_plugin/Nodes/misc/OptionButtonGenerator.gd"

var character:DialogCharacterResource setget _set_character

func generate_items() -> void:
	clear()
	add_item("None")
	set_item_metadata(0, {"portrait":-1})
	
	if not character:
		return
	
	var _idx = 1
	for portrait in character.portraits.get_resources():
		add_item(portrait.name)
		set_item_metadata(_idx, {"portrait":_idx-1})
		_idx += 1

func _set_character(value:DialogCharacterResource):
	character = value
	generate_items()
