tool
extends Event
#class_name EventJumpToEvent

export(int) var event_index:int = -1 setget set_event_idx

func _init() -> void:
	event_name = "Jump to Event"
	event_color = Color("#FBB13C")
	event_icon = load("res://addons/event_system_plugin/assets/icons/event_icons/jump_to_event.png") as Texture
	event_preview_string = "Jump to event #[ {event_index} ]"
	continue_at_end = true
	event_category = "Logic"
	event_hint = "Jumps to an event in the same timeline"
	push_warning("Event [%s] is deprecated and will be removed in future versions. Use EventGoto instead."%event_name)


func _execute(caller=null) -> void:
	push_warning("Event [%s] is deprecated and will be removed in future versions. Use EventGoto instead."%event_name)
	
	if event_index >= 0:
		var _timeline:Timeline = get_event_manager_node().timeline
		
		if not _timeline:
			finish()
			return
		
		var _events:Array = _timeline.get_events()
		var _queue:Array = []
		for event_idx in range(event_index, _events.size()):
			_queue.append(_events[event_idx])
		_events.append_array(_queue)
		_timeline._event_queue = _events.duplicate()
	
	finish()

func _get(property: String):
	if property == "continue_at_end_ignore":
		return true
	if property == "branch_disabled":
		return true


func set_event_idx(value:int) -> void:
	event_index = value
	emit_changed()
	property_list_changed_notify()
