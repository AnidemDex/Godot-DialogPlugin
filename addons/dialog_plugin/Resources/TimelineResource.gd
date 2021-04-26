tool
class_name DialogTimelineResource
extends Resource


var events = EventsArray.new()

var current_event = 0

func start(caller):
	var _err
	var _events:Array = events.get_resources()
	if not _events[current_event].is_connected("event_started", caller, "_on_event_start"):
		_err = _events[current_event].connect("event_started", caller, "_on_event_start")
		if _err != OK:
			print_debug(_err)
	if not _events[current_event].is_connected("event_finished", caller, "_on_event_finished"):
		_err = _events[current_event].connect("event_finished", caller, "_on_event_finished")
		if _err != OK:
			print_debug(_err)
	
	_events[current_event].excecute(caller)

func go_to_next_event(caller):
	current_event += 1
	current_event = clamp(current_event, 0, events.get_resources().size())
	if current_event == events.get_resources().size():
		caller.queue_free()
	else:
		start(caller)

# This method is probably unused, should be removed
func get_good_name(with_name:String="") -> String:
	var _good_name = with_name
	
	if not _good_name:
		_good_name = resource_name if resource_name else resource_path
	else:
		if _good_name.begins_with("res://"):
			_good_name = _good_name.replace("res://", "")
		if _good_name.ends_with(".tres"):
			_good_name = _good_name.replace(".tres", "")
		_good_name = _good_name.capitalize()
	
	return _good_name

# Esto debe hacerse al menos hasta que https://github.com/godotengine/godot/pull/44879
# sea añadido a Godot
func _get_property_list() -> Array:
	var properties:Array = []
	properties.append(
		{
			"name":"events",
			"type":TYPE_OBJECT,
			"hint":PROPERTY_HINT_RESOURCE_TYPE,
			"hint_string":"EventsArray",
		}
	)
	return properties
