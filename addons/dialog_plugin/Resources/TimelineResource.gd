tool
class_name DialogTimelineResource, "res://addons/dialog_plugin/assets/Images/icons/timeline_icon.png"
extends Resource

# Por si se te llega a olvidar: NO HAGAS ESTE SCRIPT CON TIPADO ESTATICO
# Generas dependencias ciclicas y luego el mundo pierde la cabeza.

const DialogUtil = preload("res://addons/dialog_plugin/Core/DialogUtil.gd")

signal timeline_ended

var events:Array = []
var current_event:int = 0

# Deprecated
var _related_characters:Array = []

func get_class() -> String: return "DialogTimelineResource"

func start(caller):
	DialogUtil.Logger.print_debug(self,"Timeline started in event %s"%current_event)
	var _err
	
	if events.empty() or current_event >= events.size():
		DialogUtil.Logger.print_debug(self,"Timeline finished")
		emit_signal("timeline_ended")
		return
	
	var _event:Resource = events[current_event]
	var _caller:Node = caller as Node
	
	connect_event_signals(_event, _caller)
	
	_event._execute(_caller)


func go_to_next_event(caller):
	current_event += 1
	start(caller)


func connect_event_signals(event:Resource, caller_node:Node) -> void:
	var _err:int
	if not event.is_connected("event_started", caller_node, "_on_event_start"):
		_err = event.connect("event_started", caller_node, "_on_event_start")
		assert(_err == OK)
	
	if not event.is_connected("event_finished", caller_node, "_on_event_finished"):
		event.connect("event_finished", caller_node, "_on_event_finished")
		assert(_err == OK)


# Esto debe hacerse al menos hasta que https://github.com/godotengine/godot/pull/44879
# sea añadido a Godot
func _get_property_list() -> Array:
	var properties:Array = []
	properties.append(
		{
			"name":"events",
			"type":TYPE_ARRAY,
			"usage":PROPERTY_USAGE_NOEDITOR|PROPERTY_USAGE_SCRIPT_VARIABLE
		}
	)
	properties.append(
		{
			"name":"_related_characters",
			"type":TYPE_ARRAY,
			"usage":PROPERTY_USAGE_NOEDITOR | PROPERTY_USAGE_SCRIPT_VARIABLE
		}
	)
	return properties
