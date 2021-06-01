tool
extends "res://addons/dialog_plugin/Nodes/editor_event_nodes/character_event/character_event_node_template.gd"

func _ready() -> void:
	if base_resource:
		emit_signal("timeline_requested", self)


func _update_node_values() -> void:
	if base_resource.character:
		character_button_node.select_item_by_resource(base_resource.character)
