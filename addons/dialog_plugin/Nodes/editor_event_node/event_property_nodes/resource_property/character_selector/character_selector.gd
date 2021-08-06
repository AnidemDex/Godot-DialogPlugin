tool
extends "res://addons/dialog_plugin/Nodes/editor_event_node/event_property_nodes/event_property.gd".PCharacterSelector

func _ready() -> void:
	if not is_connected("character_selected", self, "_on_Character_selected"):
		connect("character_selected", self, "_on_Character_selected")

func update_node_values() -> void:
	var character:DialogCharacterResource = base_resource.get(used_property)
	var character_name:String = ""
	if character:
		character_name = character.display_name
	
	set_character(character_name)

func _on_Character_selected(character:DialogCharacterResource) -> void:
	base_resource.set(used_property, character)
