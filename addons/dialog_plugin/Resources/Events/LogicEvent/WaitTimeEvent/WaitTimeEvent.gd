tool
class_name DialogWaitTimeEvent
extends "res://addons/dialog_plugin/Resources/EventResource.gd"

export(float, 0, 60, 1) var wait_time = 0.0

func _init():
	resource_name = "WaitTimeEvent"
	event_name = "Wait Time"
	event_color = Color("#FBB13C")
	event_icon = load("res://addons/dialog_plugin/assets/Images/icons/event_icons/logic/wait_icon.png") as Texture
	event_preview_string = "Wait [{wait_time}] seconds before the next event."


func execute(caller:DialogBaseNode) -> void:
	yield(caller.get_tree().create_timer(wait_time), "timeout")
	finish()
