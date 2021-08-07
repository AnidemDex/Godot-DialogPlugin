tool
class_name DialogJumpToEvent
extends DialogLogicEvent

export(int) var event_index:int = -1 setget set_event_idx

func _init() -> void:
	resource_name = "JumpToEvent"
	event_name = "Jump to Event"
	event_color = Color("#FBB13C")
	event_icon = load("res://addons/dialog_plugin/assets/Images/icons/event_icons/logic/jump_to_event.png") as Texture
	event_preview_string = "Jump to event [ {event_index} ]"
	skip = true


func execute(caller:DialogBaseNode) -> void:
	
	if event_index >= 0:
		var _timeline:DialogTimelineResource = caller.timeline
		_timeline.current_event = max(-1, event_index-1)

	# Notify that you end this event
	finish(true)


func set_event_idx(value:int) -> void:
	event_index = value
	emit_changed()
	property_list_changed_notify()


func _get(property: String):
	if property == "skip_disabled":
		return true
	if property == "branch_disabled":
		return true
