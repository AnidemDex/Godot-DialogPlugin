tool
extends "res://addons/dialog_plugin/Nodes/editor_event_node/event_property_nodes/event_property.gd".PControl

onready var portrait_node:DialogPortraitManager = $Portraits

func update_node_values() -> void:
	var position:Vector2 = Vector2()
	position.x = float(base_resource.get("percent_position_x"))
	position.y = float(base_resource.get("percent_position_y"))
	var end_position:Vector2 = portrait_node._get_relative_position(position)
	portrait_node.size_reference_node.rect_position = end_position
	
	var character:DialogCharacterResource = base_resource.get("character")
	var portrait:DialogPortraitResource = base_resource.call("get_selected_portrait")
	var flip_h = base_resource.get("flip_h")
	var flip_v = base_resource.get("flip_v")
	portrait_node.add_portrait(character, portrait, position, 0, flip_h, flip_v)
