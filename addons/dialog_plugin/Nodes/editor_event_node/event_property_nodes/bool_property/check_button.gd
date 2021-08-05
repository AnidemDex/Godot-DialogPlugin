tool
extends "res://addons/dialog_plugin/Nodes/editor_event_node/event_property_nodes/event_property.gd".PCheckButton

func _ready() -> void:
	var alternative_name:String = ""
	if base_resource:
		alternative_name = str(base_resource.get(used_property+"_alternative_name"))
		var property_disabled = base_resource.get(used_property + "_disabled")
		if property_disabled:
			disabled = true
	text = used_property.capitalize() if alternative_name == str(null) else alternative_name


func _toggled(button_pressed: bool) -> void:
	base_resource.set(used_property, button_pressed)


func update_node_values() -> void:
	pressed = base_resource.get(used_property)
