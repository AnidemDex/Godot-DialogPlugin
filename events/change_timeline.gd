tool
extends Event
#class_name EventChangeTimeline

export(String, FILE, "*.tres, *.res") var timeline_path:String = "" setget set_timeline_path
export(int) var start_from_event = 0 setget set_start_event_idx
# Do    N O T    store the timeline reference. Doing it causes cyclic references.
var timeline:Timeline

func _init() -> void:
	event_name = "Change Timeline"
	event_color = Color("#FBB13C")
	event_icon = load("res://addons/event_system_plugin/assets/icons/event_icons/change_timeline.png") as Texture
	event_preview_string = "Jump to: [ {timeline_path} ] and start in event #[ {start_from_event} ]"
	event_category = "Logic"
	continue_at_end = true
	push_warning("Event [%s] is deprecated and will be removed in future versions. Use EventGoto instead."%event_name)


func _execute() -> void:
	push_warning("Event [%s] is deprecated and will be removed in future versions. Use EventGoto instead."%event_name)
	
	if not timeline and timeline_path:
		timeline = load(timeline_path) as Timeline
	if not timeline or not(timeline is Timeline):
		finish()
		return
	
	start_from_event = max(start_from_event, 0)
	var _event_queue = timeline.get_events()
	
	for i in start_from_event:
		var _discard = _event_queue.pop_front()
	
	timeline._event_queue = _event_queue
	get_event_manager_node().start_timeline(timeline)


func set_timeline_path(value:String) -> void:
	timeline_path = value
	emit_changed()
	property_list_changed_notify()


func set_start_event_idx(value:int) -> void:
	start_from_event = value
	emit_changed()
	property_list_changed_notify()


func _get(property: String):
	if property == "continue_at_end_ignore":
		return true
	if property == "branch_disabled":
		return true

