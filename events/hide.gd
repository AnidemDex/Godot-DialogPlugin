tool
extends "res://addons/event_system_plugin/events/call_from.gd"
class_name EventHide

func _init() -> void:
	event_color = Color("EB5E55")
	event_name = "Hide"
	event_category = "Node"
	event_icon = load("res://addons/event_system_plugin/assets/icons/event_icons/hidden.png") as Texture
	method = "set"
	args = ["visible", false]
	event_preview_string = "{node_path}"


func _get(property: String):
	if property == "method_ignore":
		return true
	if property == "args_ignore":
		return true
