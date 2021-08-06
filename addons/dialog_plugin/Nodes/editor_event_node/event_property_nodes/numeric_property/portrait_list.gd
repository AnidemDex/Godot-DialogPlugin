tool
extends "res://addons/dialog_plugin/Nodes/editor_event_node/event_property_nodes/event_property.gd".POptionButton


func generate_items() -> void:
	clear()
	var character:DialogCharacterResource = base_resource.get("character")
	var selected_portrait:int = -1
	if character:
		for portrait in character.portraits:
			portrait = portrait as DialogPortraitResource
			var portrait_name:String = portrait.name
			add_icon_item(portrait.icon, portrait_name)

func update_node_values() -> void:
	generate_items()
	select(int(base_resource.get("selected_portrait")))


func _on_item_selected(index: int) -> void:
	base_resource.set(used_property, index)
