tool
extends Event
class_name EventShow

func _init() -> void:
	event_color = Color("EB5E55")
	event_name = "Show"
	event_category = "Node"
	event_icon = load("res://addons/event_system_plugin/assets/icons/event_icons/visible.png") as Texture


func _execute() -> void:
	event_node.set("visible", true)    
	finish()
