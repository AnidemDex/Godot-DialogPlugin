tool
extends "res://addons/dialog_plugin/Nodes/editor_event_node/event_property_nodes/event_property.gd".PControl

onready var portrait_node:DialogPortraitManager = $Portraits

func update_node_values() -> void:
	var position:Vector2 = Vector2()
	position.x = float(base_resource.get("percent_position_x"))
	position.y = float(base_resource.get("percent_position_y"))
	position = portrait_node._get_relative_position(position)
	portrait_node.size_reference_node.rect_position = position
