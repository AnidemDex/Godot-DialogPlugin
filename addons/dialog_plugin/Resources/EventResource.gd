tool
class_name DialogEventResource
extends Resource

## 
## Base class for all dialog events.
##
## @desc: 
##    Every dialog event relies on this class. 
##    If you want to do your own event, you should [code]extend[/code] this class.
##
## @tutorial(Online Documentation): https://anidemdex.gitbook.io/godot-dialog-plugin/documentation/resource-class/class_dialog-event-resource
##

## See [DialogUtil]
const DialogUtil = preload("res://addons/dialog_plugin/Core/DialogUtil.gd")
## See [TranslationService]
const TranslationService = preload("res://addons/dialog_plugin/Other/translation_service/translation_service.gd")
## Path to default saved variables
const VARIABLES_PATH = preload("res://addons/dialog_plugin/Core/DialogResources.gd").DEFAULT_VARIABLES_PATH

## Emmited when the event starts.
## The signal is emmited with the event resource [code]event_resource[/code]
signal event_started(event_resource)

## Emmited when the event finish. 
## The signal is emmited with the event resource [code]event_resource[/code]
## and a bool value [code]jump_to_next_event[/code]
signal event_finished(event_resource, jump_to_next_event)

##########
# Event Editor Properties
##########

## The event icon that'll be displayed in the editor
var event_icon:Texture = load("res://addons/dialog_plugin/assets/Images/icons/event_icons/warning.png")

## The event color that event node will take in the editor
var event_color:Color = Color("3c3d5e")

## The event name that'll be displayed in the editor.
## If the resource name is different from the event name, resource_name is returned instead.
var event_name:String = "CustomEvent" setget ,get_event_name

## The event preview string that'll be displayed next to the event name in the editor
## You can use String formats to parse variables from the script:
## [codeblock] event_preview_string = "{resource_name}" [/codeblock]
## Will display the resource's name instead of [code]{resource_name}[/code].
var event_preview_string:String = ""

## The event hint that'll be displayed when you hover the event button in the editor.
var event_hint:String = ""

##########
# Event Editor Node
##########
# "res://addons/dialog_plugin/Nodes/editor_event_nodes/event_node_template.tscn"

## The event editor scene path. This scene will be used instead the generated one.
var event_editor_scene_path:String = ""

## The event node preview scene path.
## The editor node will be generated, but the preview node will be replaced with this one instead.
var event_node_preview_path:String = ""

## The event properties scene path.
## The editor node will be generated, but the properties node will be replaced with this one instead.
var event_node_properties_path:String = ""

##########
# Default Event Properties
##########

## Determines if the event will go to next event inmediatly or not. 
## If skip is true, the next event will be executed after thie event ends.
var skip:bool = false setget set_skip

## The caller node of this event.
var _caller:DialogBaseNode = null

func get_class(): return "EventResource"


func _execute(caller:DialogBaseNode) -> void:
	DialogUtil.Logger.print_debug(self, "Event started")
	_caller = caller
	emit_signal("event_started", self)
	execute(caller)


## Executes the event behaviour.
func execute(caller:DialogBaseNode) -> void:
	DialogUtil.Logger.print_info(self, "execute method was not overrided")


## Ends the event behaviour.
func finish(jump_to_next_event=skip) -> void:
	DialogUtil.Logger.print_debug(self, "Event finished")
	emit_signal("event_finished", self, jump_to_next_event)


func set_skip(value:bool) -> void:
	skip = value
	emit_changed()


func get_event_name() -> String:
	if event_name != resource_name and resource_name != "":
		return resource_name
	return event_name


func _get_property_list() -> Array:
	var properties:Array = []
	var skip_property:Dictionary = DialogUtil.get_property_dict("skip", TYPE_BOOL, PROPERTY_HINT_NONE, "CheckButton", PROPERTY_USAGE_DEFAULT|PROPERTY_USAGE_SCRIPT_VARIABLE)
	properties.append(skip_property)
	return properties


func _get(property: String):
	if property == "skip_alternative_name":
		return "Jump immediately to next event?"
