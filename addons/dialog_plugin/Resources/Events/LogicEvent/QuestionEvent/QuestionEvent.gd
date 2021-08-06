tool
class_name DialogQuestionEvent
extends DialogLogicEvent

# - - - - - - - - - -
# Base class for all dialog events
# - - - - - - - - - -
# You can read more about this class in the Documentation
# https://anidemdex.gitbook.io/godot-dialog-plugin/documentation/resource-class/class_dialog-event-resource

var options:Dictionary = {}

var OptionsManager:DialogOptionsManager

var _old_timeline:DialogTimelineResource

func _init() -> void:
	# Uncomment resource_name line if you want to display a name in the editor
	event_name = "Question"
	resource_name = event_name
	event_color = Color("#FBB13C")
	event_icon = load("res://addons/dialog_plugin/assets/Images/icons/event_icons/logic/question_event.png") as Texture

	# Uncomment skip line if you want your event jump directly to next event 
	# at finish or not (false by default)
	skip = true


func execute(caller:DialogBaseNode) -> void:
	
	caller.visible = true
	
	OptionsManager = caller.OptionsContainer
	
	if not OptionsManager:
		finish(true)
		return
	
	for option in options.keys():
		OptionsManager.add_option(option)
	
	OptionsManager.connect("option_selected", self, "_on_option_selected")


func _on_option_selected(option) -> void:
	var timeline:DialogTimelineResource = options.get(option, null)
	_old_timeline = _caller.timeline
	
	if timeline and not(timeline.events.empty()):
		timeline.current_event = -1
		timeline.connect("timeline_ended", self, "_on_Timeline_ended", [], CONNECT_ONESHOT)
		_caller.timeline = timeline
	
	finish(true)


func _on_Timeline_ended() -> void:
	_caller.timeline = _old_timeline
	_old_timeline = null
	finish(true)


func _get_property_list() -> Array:
	var _p:Array = []
	var options_property:Dictionary = DialogUtil.get_property_dict("options", TYPE_DICTIONARY, PROPERTY_HINT_NONE, "" ,PROPERTY_USAGE_NOEDITOR|PROPERTY_USAGE_SCRIPT_VARIABLE)
	_p.append(options_property)
	return _p
