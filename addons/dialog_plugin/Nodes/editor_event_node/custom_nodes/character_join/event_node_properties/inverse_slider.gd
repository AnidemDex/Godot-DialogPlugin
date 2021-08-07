tool
extends "res://addons/dialog_plugin/Nodes/editor_event_node/event_property_nodes/event_property.gd".PSlider

func update_node_values() -> void:
	value = -base_resource.get(used_property)

func _on_value_changed(new_value:float) -> void:
	base_resource.set(used_property, -new_value)
