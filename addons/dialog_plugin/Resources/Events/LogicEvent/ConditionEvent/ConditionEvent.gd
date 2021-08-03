tool
# class_name <your_event_class_name_here>
extends "res://addons/dialog_plugin/Resources/EventResource.gd"

export(String) var condition:String = ""

var events_if:DialogTimelineResource = DialogTimelineResource.new()
var events_else:DialogTimelineResource = DialogTimelineResource.new()

var old_timeline:DialogTimelineResource

func get_class() -> String: return "ConditionEvent"

func _init() -> void:
	# Uncomment resource_name line if you want to display a name in the editor
	resource_name = "IF|ELSE"
	event_name = "Condition"
	event_color = Color("#FBB13C")
	event_icon = load("res://addons/dialog_plugin/assets/Images/icons/event_icons/logic/condition_event.png") as Texture
	event_preview_string = "If [ {condition} ]:"
	skip = true


func execute(caller:DialogBaseNode) -> void:

	old_timeline = caller.timeline
	
	var variables:Dictionary = load(VARIABLES_PATH).variables
	
	var evaluated_condition = DialogUtil.evaluate(condition, caller, variables)
	DialogUtil.Logger.print_debug(self, [condition,": ",evaluated_condition])
	
	var timeline:DialogTimelineResource
	
	if evaluated_condition and (str(evaluated_condition) != condition):
		timeline = events_if
	else:
		timeline = events_else
	
	if timeline and not(timeline.events.empty()):
		timeline.connect("timeline_ended", self, "_on_Timeline_ended", [], CONNECT_ONESHOT)
		timeline.current_event = -1
		caller.timeline = timeline
	
	finish(true)


func _on_Timeline_ended() -> void:
	_caller.timeline = old_timeline
	old_timeline = null
	finish(true)


func _get_property_list() -> Array:
	var _p:Array = []
	var if_evnt_property := DialogUtil.get_event_property_dict("events_if", TYPE_OBJECT, PROPERTY_HINT_RESOURCE_TYPE, "DialogTimelineResource")
	var else_evnt_property := DialogUtil.get_event_property_dict("events_else", TYPE_OBJECT, PROPERTY_HINT_RESOURCE_TYPE, "DialogTimelineResource")
	
	_p.append_array([if_evnt_property, else_evnt_property])
	return _p

func _get(property: String):
	if property == "skip_disabled":
		return true
