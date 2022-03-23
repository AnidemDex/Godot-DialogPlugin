tool
extends Event
class_name EventEmitSignal

export(String) var data:String = "" setget _set_data

func _init() -> void:
	event_name = "Emit Signal"
	event_color = Color("EB5E55")
	event_icon = load("res://addons/event_system_plugin/assets/icons/event_icons/emit_signal.png") as Texture
	event_preview_string = "Emit signal with [ '{data}' ] value"
	event_hint = "Emits EventManager 'custom_signal' with passed value as string"
	event_category = "Node"

func _execute() -> void:
	get_event_manager_node().emit_signal("custom_signal", data)
	finish()


func _set_data(value:String) -> void:
	data = value
	emit_changed()
	property_list_changed_notify()
