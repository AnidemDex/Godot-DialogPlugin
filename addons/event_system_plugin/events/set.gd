tool
extends Event
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


func _execute() -> void:
	event_node.set(variable_name, variable_value)
	finish()


func set_var_name(value:String) -> void:
	variable_name = value
	emit_changed()
	property_list_changed_notify()


func set_var_value(value:String) -> void:
	variable_value = value
	emit_changed()
	property_list_changed_notify()


func _get(property: String):
	if property == "continue_at_end_ignore":
		return true
