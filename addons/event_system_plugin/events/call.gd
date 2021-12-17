tool
extends Event
class_name EventCall

export(String) var method:String = "" setget set_method
export(Array) var args:Array = []

func _init() -> void:
	event_color = Color("EB5E55")
	event_name = "Call"
	event_category = "Node"
	event_icon = load("res://addons/event_system_plugin/assets/icons/event_icons/call.png") as Texture
	event_preview_string = "{method} ( {args} ) "

	args = []


func _execute() -> void:
	event_node.callv(method, args)
	finish()


func set_method(value:String) -> void:
	method = value
	emit_changed()
	property_list_changed_notify()


func set_args(value:Array) -> void:
	args = value.duplicate()
	emit_changed()
	property_list_changed_notify()
