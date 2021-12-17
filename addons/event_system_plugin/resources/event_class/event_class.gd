tool
extends Resource
class_name Event, "res://addons/event_system_plugin/assets/icons/timeline_icon.png"

## 
## Base class for all events.
##
## @desc: 
##    Every event relies on this class. 
##    If you want to do your own event, you should [code]extend[/code] this class.
##

## Emmited when the event starts.
## The signal is emmited with the event resource [code]event_resource[/code]
signal event_started(event_resource)

## Emmited when the event finish. 
## The signal is emmited with the event resource [code]event_resource[/code]
signal event_finished(event_resource)

##########
# Default Event Properties
##########

## Determines if the event will go to next event inmediatly or not. 
## If value is true, the next event will be executed when event ends.
export(bool) var continue_at_end:bool = true setget _set_continue


var event_node:Node

##########
# Event Editor Properties
##########

## The event icon that'll be displayed in the editor
var event_icon:Texture = load("res://addons/event_system_plugin/assets/icons/event_icons/warning.png")

## The event color that event node will take in the editor
var event_color:Color = Color("FBB13C")

## The event name that'll be displayed in the editor.
## If the resource name is different from the event name, resource_name is returned instead.
var event_name:String = "Event" setget ,get_event_name

## The event preview string that will be displayed next to the event name in the editor.
## You can use String formats to parse variables from the script:
## [codeblock] event_preview_string = "{resource_name}" [/codeblock]
## Will display the resource's name instead of [code]{resource_name}[/code].
var event_preview_string:String = ""

## The event hint that'll be displayed when you hover the event button in the editor.
var event_hint:String = ""

var event_category:String = "Custom"


var event_manager:Node

## Executes the event behaviour.
func execute(_event_node=null) -> void:
	event_node = _event_node
	
	emit_signal("event_started", self)
	
	call_deferred("_execute")


## Ends the event behaviour.
func finish() -> void:
	emit_signal("event_finished", self)


func _execute() -> void:
	finish()


func get_event_name() -> String:
	if event_name != resource_name and resource_name != "":
		return resource_name
	return event_name


func _set_continue(value:bool) -> void:
	continue_at_end = value
	property_list_changed_notify()
	emit_changed()

func _to_string() -> String:
	return "[{event_name}:{id}]".format({"event_name":event_name, "id":get_instance_id()})


func _hide_script_from_inspector():
	return true
