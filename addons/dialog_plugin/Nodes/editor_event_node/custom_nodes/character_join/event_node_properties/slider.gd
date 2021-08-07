tool
extends "res://addons/dialog_plugin/Nodes/editor_event_node/event_property_nodes/event_property.gd".PSlider

var _val:float = 0.0

func update_node_values() -> void:
	_val = float(base_resource.get(used_property))
	value = _val


func _on_value_changed(new_value: float) -> void:
	base_resource.set(used_property, new_value)
