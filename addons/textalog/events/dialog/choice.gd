tool
extends Event
class_name EventDialogChoice

var options:Dictionary = {}

var _options_manager:OptionsManager

func add_option(option_name:String) -> void:
	options[option_name] = _get_empty_timeline("Option "+option_name)
	emit_changed()
	property_list_changed_notify()


func get_option(option_name:String) -> Timeline:
	return options.get(option_name, null) as Timeline


func remove_option(option_name:String) -> void:
	var option_was_removed := options.erase(option_name)
	if option_was_removed:
		emit_changed()
		property_list_changed_notify()


func _set_option(option_name:String, value) -> void:
	options[option_name] = value
	emit_changed()
	property_list_changed_notify()


func _set(property: String, value) -> bool:
	if property.begins_with("options/"):
		var key = property.replace("options/", "")
		_set_option(key, value)
		return true
	
	return false


func _get(property: String):
	if property.begins_with("options/"):
		var key = property.replace("options/","")
		if options.has(key):
			return options[key]
	
	if property == "custom_event_node":
		return load("res://addons/textalog/events/dialog/choice_event_node/choice_event.tscn").instance()
	
	if property == "q_options":
		return options.size()
	
	return null


func _on_option_selected(option) -> void:
	var curr_tmln:Timeline = event_manager.timeline
	var curr_queue := curr_tmln._event_queue.duplicate()
	
	var timeline:Timeline = options[option] as Timeline
	var events:Array = timeline.get_events()
	events.invert()
	
	for event in events:
		curr_queue.push_front(event)
	curr_tmln._event_queue = curr_queue
	finish()


func _execute() -> void:
	event_node = event_node as DialogNode
	if not is_instance_valid(event_node):
		finish()
		return
	
	_options_manager = event_node.options_manager as OptionsManager
	if not is_instance_valid(_options_manager):
		finish()
		return
	
	_options_manager.show()
	
	for option in options:
		_options_manager.add_option(option)
	
	_options_manager.connect("option_selected", self, "_on_option_selected", [], CONNECT_ONESHOT)


func property_can_revert(property):
	if property.begins_with("options/"):
		property = property.replace("options/", "")
		if options.has(property):
			return true
	return false


func property_get_revert(property):
	if property.begins_with("options/"):
		property = property.replace("options/", "")
		if options.has(property):
			return _get_empty_timeline("Option "+property)


func _get_empty_timeline(with_name:String="") -> Timeline:
	var tmln := Timeline.new()
	if with_name != "":
		tmln.resource_name = with_name
	return tmln


func _get_property_list() -> Array:
	var p := []
	
	for option in options:
		p.append(
			{
				"name":"options/"+str(option),
				"type":TYPE_OBJECT,
				"usage":PROPERTY_USAGE_DEFAULT|PROPERTY_USAGE_SCRIPT_VARIABLE,
				"hint":PROPERTY_HINT_RESOURCE_TYPE,
			}
		)
	
	p.append(
		{
			"name":"q_options",
			"type":TYPE_INT,
			"usage":PROPERTY_USAGE_NO_INSTANCE_STATE
		}
	)
	return p


func _init() -> void:
	event_color = Color("2892D7")
	event_name = "Choice"
	event_icon = load("res://addons/textalog/assets/icons/event_icons/question_event.png") as Texture
	event_preview_string = "User will choose between [ {q_options} ] options."
	options = options.duplicate()
	event_category = "Dialog"
