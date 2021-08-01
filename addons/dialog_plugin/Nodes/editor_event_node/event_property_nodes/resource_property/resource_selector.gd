extends "res://addons/dialog_plugin/Nodes/editor_event_node/event_property_nodes/event_property.gd".PResourceSelector

func _ready() -> void:
	connect("resource_selected", self, "_on_resource_selected")

func update_node_values() -> void:
	text = str(base_resource.get(used_property))

func _on_resource_selected(resource:Resource) -> void:
	base_resource.set(used_property, resource)
