tool
extends "res://addons/dialog_plugin/Nodes/misc/OptionButtonGenerator.gd"

var character:DialogCharacterResource setget _set_character

func generate_items() -> void:
	if not character:
		return
	
	var _idx = 1
	for portrait in character.portraits.get_resources():
		var _portrait:DialogPortraitResource = portrait
		
		add_item(_portrait.name)
		set_item_metadata(_idx, {"portrait":_portrait})
		_idx += 1


func _set_character(value:DialogCharacterResource):
	character = value
	generate_items()
