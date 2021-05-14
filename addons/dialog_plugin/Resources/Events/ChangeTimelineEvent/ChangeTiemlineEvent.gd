tool
class_name DialogChangeTimelineEvent
extends DialogEventResource

export(int) var start_from_event = 0
var timeline:DialogTimelineResource

func _init() -> void:
	# Uncomment resource_name line if you want to display a name in the editor
	resource_name = "ChangeTimelineEvent"

	# Uncomment event_editor_scene_path line and replace it with your custom DialogEditorEventNode scene
	#event_editor_scene_path = "res://path/to/your/editor/node/scene.tscn"

	# Uncomment skip line if you want your event jump directly to next event 
	# at finish or not (false by default)
	#skip = false
	pass


func excecute(caller:DialogBaseNode) -> void:
	# Parent function must be called at the start
	.excecute(caller)
	
	if not timeline or not(timeline is DialogTimelineResource):
		finish(true)
		return
	
	start_from_event = max(start_from_event, 0)
	timeline.current_event = start_from_event-1
	caller.timeline = timeline
	
	
	finish(true)


func _get_property_list() -> Array:
	var properties:Array = []
	properties.append(
		{
			"name":"timeline",
			"type":TYPE_OBJECT,
			"hint":PROPERTY_HINT_RESOURCE_TYPE,
			"hint_string":"DialogTimelineResource",
		}
	)
	return properties
