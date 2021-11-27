tool
extends Event

var options:Dictionary = {}

var _options_manager:OptionsManager

func add_option(option_name:String) -> void:
	options[option_name] = Timeline.new()
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
			return Timeline.new()


func _get_property_list() -> Array:
	var p := []
	
	p.append(
		{
			"name":"Options",
			"type":TYPE_NIL,
			"usage":PROPERTY_USAGE_CATEGORY
		}
	)
	for option in options:
		p.append(
			{
				"name":"options/"+str(option),
				"type":TYPE_OBJECT,
				"usage":PROPERTY_USAGE_DEFAULT|PROPERTY_USAGE_SCRIPT_VARIABLE,
				"hint":PROPERTY_HINT_RESOURCE_TYPE,
			}
		)
	
	return p


func _init() -> void:
	event_color = Color("2892D7")
	event_name = "Choice"
	event_icon = load("res://addons/textalog/assets/icons/event_icons/question_event.png") as Texture
	
	options = options.duplicate()
