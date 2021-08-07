tool
extends "res://addons/dialog_plugin/Nodes/editor_event_node/event_property_nodes/event_property.gd".PResourceSelector

func _ready() -> void:
	if not is_connected("resource_selected", self, "_on_resource_selected"):
		connect("resource_selected", self, "_on_resource_selected")

func update_node_values() -> void:
	var resource:Resource = base_resource.get(used_property)
	var final_text:String = str(null)
	if resource:
		final_text = resource.resource_path.get_file()
	text = "[None]" if final_text == str(null) else final_text

func _on_resource_selected(resource:Resource) -> void:
	base_resource.set(used_property, resource)
