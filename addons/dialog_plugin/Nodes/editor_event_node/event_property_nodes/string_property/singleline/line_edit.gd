tool
extends "res://addons/dialog_plugin/Nodes/editor_event_node/event_property_nodes/event_property.gd".PControl

onready var label_node:Label = $Label as Label
onready var line_edit_node:LineEdit = $LineEdit as LineEdit

func update_node_values() -> void:
	label_node.text = used_property.capitalize()
	line_edit_node.text = str(base_resource.get(used_property))


func _on_LineEdit_text_entered(new_text: String) -> void:
	base_resource.set(used_property, new_text)


func _on_LineEdit_focus_exited() -> void:
	base_resource.set(used_property, line_edit_node.text)
