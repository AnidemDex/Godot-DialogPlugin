tool
class_name DialogEventResource
extends Resource

const DialogUtil = preload("res://addons/dialog_plugin/Core/DialogUtil.gd")
const TranslationService = preload("res://addons/dialog_plugin/Other/translation_service/translation_service.gd")
const VARIABLES_PATH = preload("res://addons/dialog_plugin/Core/DialogResources.gd").DEFAULT_VARIABLES_PATH

signal event_started(event_resource)
signal event_finished(event_resource, jump_to_next_event)

##########
# Event Editor Properties
##########

var event_icon:Texture = load("res://addons/dialog_plugin/assets/Images/icons/event_icons/warning.png")
var event_color:Color = Color("3c3d5e")
var event_name:String = "CustomEvent" setget ,get_event_name
var event_preview_string:String = ""
var event_hint:String = ""

##########
# Event Editor Node
##########
# "res://addons/dialog_plugin/Nodes/editor_event_nodes/event_node_template.tscn"
var event_editor_scene_path:String = ""
var event_node_preview_path:String = ""
var event_node_properties_path:String = ""

##########
# Default Event Properties
##########
var skip:bool = false setget set_skip

var _caller:DialogBaseNode = null

func get_class(): return "EventResource"

func _execute(caller:DialogBaseNode) -> void:
	DialogUtil.Logger.print_debug(self, "Event started")
	_caller = caller
	emit_signal("event_started", self)
	execute(caller)


func execute(caller:DialogBaseNode) -> void:
	DialogUtil.Logger.print_info(self, "execute method was not overrided")


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
