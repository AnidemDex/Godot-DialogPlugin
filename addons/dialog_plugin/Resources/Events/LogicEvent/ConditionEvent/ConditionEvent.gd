tool
# class_name <your_event_class_name_here>
extends "res://addons/dialog_plugin/Resources/EventResource.gd"

var condition:String = ""

var events_if:DialogTimelineResource = DialogTimelineResource.new()
var events_else:DialogTimelineResource = DialogTimelineResource.new()

var old_timeline:DialogTimelineResource

func _init() -> void:
	# Uncomment resource_name line if you want to display a name in the editor
	resource_name = "IF|ELSE"

	# Uncomment event_editor_scene_path line and replace it with your custom DialogEditorEventNode scene
	event_editor_scene_path = "res://addons/dialog_plugin/Nodes/editor_event_nodes/if_else_event/if_else_event_node.tscn"

	# Uncomment skip line if you want your event jump directly to next event 
	# at finish or not (false by default)
	#skip = false


func execute(caller:DialogBaseNode) -> void:

	old_timeline = caller.timeline
	
	var variables:Dictionary = load(VARIABLES_PATH).variables
	
	var evaluated_condition = DialogUtil.evaluate(condition, caller, variables)
#	print(condition,": ",evaluated_condition)
	
	var timeline:DialogTimelineResource
	
	if evaluated_condition and (str(evaluated_condition) != condition):
		timeline = events_if
	else:
		timeline = events_else
	
	if timeline and not(timeline.events.empty()):
		timeline.connect("timeline_ended", self, "_on_Timeline_ended", [], CONNECT_ONESHOT)
		caller.timeline = timeline
	
	finish(true)


func _on_Timeline_ended() -> void:
	_caller.timeline = old_timeline
	old_timeline = null
	finish(true)


func _get_property_list() -> Array:
	var _p:Array = []
	_p.append(
		{
			"name":"events_if",
			"type":TYPE_OBJECT,
			"usage":PROPERTY_USAGE_NOEDITOR|PROPERTY_USAGE_SCRIPT_VARIABLE
		}
	)
	_p.append(
		{
			"name":"events_else",
			"type":TYPE_OBJECT,
			"usage":PROPERTY_USAGE_NOEDITOR|PROPERTY_USAGE_SCRIPT_VARIABLE
		}
	)
	_p.append(
		{
			"name":"condition",
			"type":TYPE_STRING,
			"usage":PROPERTY_USAGE_SCRIPT_VARIABLE|PROPERTY_USAGE_DEFAULT
		}
	)
	return _p
