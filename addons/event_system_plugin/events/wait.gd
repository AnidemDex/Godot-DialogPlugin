tool
extends Event
class_name EventWait

export(float) var wait_time = 0.0 setget set_wait_time

func _init():
	event_name = "Wait"
	event_color = Color("#FBB13C")
	event_icon = load("res://addons/event_system_plugin/assets/icons/event_icons/wait_icon.png") as Texture
	event_category = "Logic"
	event_preview_string = "Wait [{wait_time}] seconds before the next event."


func _execute() -> void:
	var _timer = get_event_node().get_tree().create_timer(wait_time)
	_timer.connect("timeout", self, "finish")


func set_wait_time(value:float) -> void:
	wait_time = value
	emit_changed()
	property_list_changed_notify()
