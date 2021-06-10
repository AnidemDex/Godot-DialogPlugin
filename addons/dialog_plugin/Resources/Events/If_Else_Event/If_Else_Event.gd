tool
# class_name <your_event_class_name_here>
extends DialogEventResource

var condition:String = ""

var events_if:Array = []
var events_else:Array = []

var old_timeline:DialogTimelineResource

func _init() -> void:
	# Uncomment resource_name line if you want to display a name in the editor
	resource_name = "IF|ELSE"

	# Uncomment event_editor_scene_path line and replace it with your custom DialogEditorEventNode scene
	#event_editor_scene_path = "res://path/to/your/editor/node/scene.tscn"

	# Uncomment skip line if you want your event jump directly to next event 
	# at finish or not (false by default)
	#skip = false


func execute(caller:DialogBaseNode) -> void:
	# Parent function must be called at the start
	.execute(caller)
	
	old_timeline = caller.timeline
	
	var variables:Dictionary = load(VARIABLES_PATH).variables
	var DialogUtil = preload("res://addons/dialog_plugin/Core/DialogUtil.gd")
	
	var evaluated_condition = DialogUtil.evaluate(condition, caller, variables)
	print(condition,": ",evaluated_condition)
	
	var timeline:DialogTimelineResource = DialogTimelineResource.new()
	timeline.connect("timeline_ended", self, "_on_Timeline_ended", [], CONNECT_ONESHOT)
	
	if evaluated_condition and (str(evaluated_condition) != condition):
		timeline.events._resources = events_if.duplicate()
	else:
		timeline.events._resources = events_else.duplicate()
	
	caller.timeline = timeline
	finish(true)


func _on_Timeline_ended() -> void:
	print("timeline ended")
	_caller.timeline = old_timeline
	old_timeline = null
	finish(true)


func _get_property_list() -> Array:
	var _p:Array = []
	_p.append(
		{
			"name":"events_if",
			"type":TYPE_ARRAY,
			"usage":PROPERTY_USAGE_NOEDITOR|PROPERTY_USAGE_SCRIPT_VARIABLE
		}
	)
	_p.append(
		{
			"name":"events_else",
			"type":TYPE_ARRAY,
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
