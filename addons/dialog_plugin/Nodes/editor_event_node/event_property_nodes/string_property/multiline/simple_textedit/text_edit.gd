tool
extends "res://addons/dialog_plugin/Nodes/editor_event_node/event_property_nodes/event_property.gd".PTextEdit

func update_node_values() -> void:
	text = str(base_resource.get(used_property))


func focus_lost():
	base_resource.set(used_property, text)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_FOCUS_EXIT:
			focus_lost()
