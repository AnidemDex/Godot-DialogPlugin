tool
extends Event
class_name EventHide

func _init() -> void:
	event_color = Color("EB5E55")
	event_name = "Hide"
	event_category = "Node"
	event_icon = load("res://addons/event_system_plugin/assets/icons/event_icons/hidden.png") as Texture


func _execute() -> void:
	event_node.set("visible", false)    
	finish()
