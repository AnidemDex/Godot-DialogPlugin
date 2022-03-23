tool
extends "res://addons/event_system_plugin/events/call_from.gd"
class_name EventSet

export(String) var variable_name:String = "" setget set_var_name
export(String) var variable_value:String = "" setget set_var_value

func _init() -> void:
	event_name = "Set Variable"
	event_category = "Node"
	event_color = Color("EB5E55")
	event_icon = load("res://addons/event_system_plugin/assets/icons/event_icons/set_variable.png") as Texture
	event_preview_string = "Set [ {variable_name} ] to be [ {variable_value} ]"
	continue_at_end = true
	method = "set"
	args = ["",""]


func set_var_name(value:String) -> void:
	variable_name = value
	args[0] = variable_name
	emit_changed()
	property_list_changed_notify()


func set_var_value(value:String) -> void:
	variable_value = value
	args[1] = variable_value
	emit_changed()
	property_list_changed_notify()


func _get(property: String):
	if property == "continue_at_end_ignore":
		return true
	if property == "method_ignore":
		return true
	if property == "args_ignore":
		return true
