tool
extends "res://addons/event_system_plugin/events/call_from.gd"

func _init() -> void:
	event_color = Color("EB5E55")
	event_name = "Call"
	event_category = "Node"
	event_icon = load("res://addons/event_system_plugin/assets/icons/event_icons/call.png") as Texture
	event_preview_string = "{method} ( {args} ) "

	args = []
	push_warning("Call event is deprecated. Will be removed in future versions. Consider using EventCallFrom")


func set_method(value:String) -> void:
	method = value
	emit_changed()
	property_list_changed_notify()


func set_args(value:Array) -> void:
	args = value.duplicate()
	emit_changed()
	property_list_changed_notify()
