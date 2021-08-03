tool
class_name DialogChangeTimelineEvent
extends "res://addons/dialog_plugin/Resources/EventResource.gd"

export(int) var start_from_event = 0
var timeline_path:String = ""
# Do    N O T    store the timeline reference. Doing it causes cyclic references.
var timeline:DialogTimelineResource

func _init() -> void:
	# Uncomment resource_name line if you want to display a name in the editor
	resource_name = "ChangeTimelineEvent"
	event_name = "Change Timeline"
	event_color = Color("#FBB13C")
	event_icon = load("res://addons/dialog_plugin/assets/Images/icons/event_icons/logic/change_timeline.png") as Texture
	event_preview_string = "Jump to: [ {timeline_path} ] and start in event #[ {start_from_event} ]"
	skip = true
	


func execute(caller:DialogBaseNode) -> void:
	
	if not timeline and timeline_path:
		timeline = load(timeline_path) as DialogTimelineResource
	if not timeline or not(timeline is DialogTimelineResource):
		push_warning("[Dialog Event] There was no timeline to load, skipping")
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
