tool
extends Resource
class_name Timeline, "res://addons/event_system_plugin/assets/icons/timeline_icon.png"

# Can't reference:
#	- EventManager node
#	- Event
# Note for future devs: Keep this resource as an event container. No magic tricks

# deprecated
var last_event = null
# deprecated
var next_event = null

# deprecated
var _curr_evnt_idx:int = -1

var _events:Array = [] setget set_events

# deprecated
var _event_queue:Array = []
# deprecated
var _can_loop:bool = false setget ,can_loop


# deprecated
func initialize() -> void:
	push_warning("Timeline.initialize() is deprecated and will be removed in future versions")
#	_event_queue = get_events()
	return


# deprecated
func event_changed() -> void:
	push_warning("Timeline.event_changed() is deprecated and will be removed in future versions")
#	emit_changed()
#	property_list_changed_notify()
	return


func set_events(events:Array) -> void:
	_events = events
	emit_changed()
	property_list_changed_notify()


func add_event(event, at_position=-1) -> void:
	var idx = at_position if at_position > -1 else _events.size()
	_events.insert(idx, event)
	emit_changed()
	property_list_changed_notify()


func erase_event(event) -> void:
	_events.erase(event)
	emit_changed()
	property_list_changed_notify()


func remove_event(position:int) -> void:
	_events.remove(position)
	emit_changed()
	property_list_changed_notify()


func get_events() -> Array:
	return _events.duplicate()


func get_next_event() -> Resource:
	push_warning("Timeline.get_next_event() is deprecated and will be removed in future versions")
#	_curr_evnt_idx += 1
#	_update_last_n_next_events()
#	return _event_queue.pop_front()
	return null


func can_loop() -> bool:
	return _can_loop


# Deprecated
func get_previous_event() -> Resource:
	return null


# Deprecated
func _update_last_n_next_events() -> void:
	return


func _set(property:String, value) -> bool:
	var has_property := false
	
	if property.begins_with("event/"):
		var event_idx:int = int(property.split("/", true, 2)[1])
		if event_idx < _events.size():
			_events[event_idx] = value
		else:
			_events.insert(event_idx, value)
		
		has_property = true
		emit_changed()
	
	return has_property


func _get(property:String):
	if property.begins_with("event/"):
		var event_idx:int = int(property.split("/", true, 2)[1])
		if event_idx < _events.size():
			return _events[event_idx]


func _init() -> void:
	_events = []
	resource_name = get_class()


func _to_string() -> String:
	return "[{class}:{id}]".format({"class":get_class(), "id":get_instance_id()})


func get_class() -> String: return "Timeline"


func _get_property_list() -> Array:
	var p = []
	for event_idx in _events.size():
		p.append(
			{
				"name":"event/{idx}".format({"idx":event_idx}),
				"type":TYPE_OBJECT,
				"usage":PROPERTY_USAGE_DEFAULT|PROPERTY_USAGE_SCRIPT_VARIABLE
			}
		)
	return p
