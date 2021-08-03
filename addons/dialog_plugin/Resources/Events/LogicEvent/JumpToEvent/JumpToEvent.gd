tool
class_name DialogJumpToEvent
extends "res://addons/dialog_plugin/Resources/EventResource.gd"

export(int) var event_index:int = -1

func _init() -> void:
	resource_name = "JumpToEvent"
	event_name = "Jump to Event"
	event_color = Color("#FBB13C")
	skip = true


func execute(caller:DialogBaseNode) -> void:
	
	if event_index >= 0:
		var _timeline:DialogTimelineResource = caller.timeline
		_timeline.current_event = max(-1, event_index-1)

	# Notify that you end this event
	finish()
