tool
extends "res://addons/dialog_plugin/Nodes/editor_event_node/event_property_nodes/string_property/singleline/line_edit.gd"

func update_node_values() -> void:
	label_node.text = used_property.capitalize()
	var translation_key:String = str(base_resource.get(used_property))
	
	if translation_key == "__SAME_AS_TEXT__":
		translation_key = ""
	
	line_edit_node.text = translation_key

func _on_LineEdit_text_entered(new_text: String) -> void:
	if new_text == "":
		new_text = "__SAME_AS_TEXT__"
	base_resource.set(used_property, new_text)


func _on_LineEdit_focus_exited() -> void:
	var new_text:String = line_edit_node.text
	if new_text == "":
		new_text = "__SAME_AS_TEXT__"
	base_resource.set(used_property, new_text)
