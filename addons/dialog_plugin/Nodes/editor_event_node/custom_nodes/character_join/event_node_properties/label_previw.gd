tool
extends "res://addons/dialog_plugin/Nodes/editor_event_node/event_property_nodes/event_property.gd".PLabel

export(String) var preview:String = ""

func update_node_values() -> void:
	var value:float = base_resource.get(used_property) * 100
	text = preview.format({"property":value})
