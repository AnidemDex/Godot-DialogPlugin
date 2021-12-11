tool
extends Resource
class_name Timeline, "res://addons/event_system_plugin/assets/icons/timeline_icon.png"

# Can't reference:
#	- EventManager node
#	- Event

var last_event = null
var next_event = null
var _curr_evnt_idx:int = -1

var _events:Array = []
var _event_queue:Array = []
var _can_loop:bool = false setget ,can_loop


func initialize() -> void:
	_event_queue = get_events()


func add_event(event, at_position=-1) -> void:
	if at_position >= 0:
		_events.insert(at_position, event)
	else:
		_events.append(event)
	emit_changed()


func erase_event(event) -> void:
	_events.erase(event)
	emit_changed()


func remove_event(position:int) -> void:
	_events.remove(position)
	emit_changed()


func get_events() -> Array:
	return _events.duplicate()


func get_next_event() -> Resource:
	_curr_evnt_idx += 1
	_update_last_n_next_events()
	return _event_queue.pop_front()


func can_loop() -> bool:
	return _can_loop


func get_previous_event() -> Resource:
	return null


func _update_last_n_next_events() -> void:
	var _l_evnt_idx = _curr_evnt_idx-1
	var _n_evnt_idx = _curr_evnt_idx+1
	
	if _l_evnt_idx >= 0 and _l_evnt_idx < _events.size():
		last_event = _events[_l_evnt_idx]
	else:
		last_event = null
	
	if _n_evnt_idx >= 0 and _n_evnt_idx < _events.size():
		next_event = _events[_n_evnt_idx]
	else:
		next_event = null


func _init() -> void:
	_events = []
	_event_queue = []
	resource_name = get_class()


func _to_string() -> String:
	return "[{class}:{id}]".format({"class":get_class(), "id":get_instance_id()})


func get_class() -> String: return "Timeline"


func _get_property_list() -> Array:
	var p = []
	p.append(
		{
			"name":"_events",
			"type":TYPE_ARRAY,
			"usage":PROPERTY_USAGE_NOEDITOR|PROPERTY_USAGE_SCRIPT_VARIABLE
		}
	)
	return p
