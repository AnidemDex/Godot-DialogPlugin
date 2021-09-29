tool
class_name DialogTimelineResource, "res://addons/dialog_plugin/assets/Images/icons/timeline_icon.png"
extends Resource

##
## Base class for all timeline resources.
##
## @tutorial(Using timeline in game): https://anidemdex.gitbook.io/godot-dialog-plugin/getting-started/using-the-timeline-in-game
## @tutorial(Creating a timeline): https://anidemdex.gitbook.io/godot-dialog-plugin/getting-started/creating-a-timeline
## @tutorial(Online Documentation): https://anidemdex.gitbook.io/godot-dialog-plugin/documentation/resource-class/class_dialog-timeline-resource
##

# Por si se te llega a olvidar: NO HAGAS ESTE SCRIPT CON TIPADO ESTATICO
# Generas dependencias ciclicas y luego el mundo pierde la cabeza.

## See [DialogUtil]
const DialogUtil = preload("res://addons/dialog_plugin/Core/DialogUtil.gd")

## Emmited when the timeline ends.
signal timeline_ended

## Events of this timeline.
var events:Array = []

## The current event index of the timeline.
var current_event:int = 0

# Deprecated
var _related_characters:Array = []

func get_class() -> String: return "DialogTimelineResource"

## Execute the [code]current_event[/code] in events.
func start(caller):
	DialogUtil.Logger.print_debug(self,"Timeline started in event %s"%current_event)
	var _err
	
	if events.empty() or current_event >= events.size():
		DialogUtil.Logger.print_debug(self,"Timeline finished")
		emit_signal("timeline_ended")
		return
	
	var _event:Resource = events[current_event]
	var _caller:Node = caller as Node
	
	_connect_event_signals(_event, _caller)
	
	_event._execute(_caller)


## Try to execute the next event in events. 
## If there are no more events, [signal timeline_ended] is emmited.
func go_to_next_event(caller):
	current_event += 1
	start(caller)


#func add_event(event:DialogEventResource, at_position:int=-1) -> void:
# We can't do that  because  C I C L Y C   D E P E N D E N C Y

## Add an event to [member events]
func add_event(event, at_position:int=-1) -> void:
	if at_position > -1:
		at_position = min(events.size(), at_position)
		events.insert(at_position, event)
	else:
		events.append(event)
	emit_changed()


#func remove_event(event:DialogEventResource) -> void:

## Remove an event from [member events]
func remove_event(event) -> void:
	events.erase(event)
	emit_changed()


func _connect_event_signals(event:Resource, caller_node:Node) -> void:
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
