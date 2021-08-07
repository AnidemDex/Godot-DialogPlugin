tool

const Dialog_MARK = "[Dialog]"
const Dialog_INFO = "[Info]"
const Dialog_DEBUG = "[Debug]"
const Dialog_ERROR = "[Error]"

class Error:
	const TIMELINE_NOT_FOUND = "TIMELINE_NOT_FOUND"
	const TIMELINE_NOT_SELECTED = "TIMELINE_NOT_SELECTED"
	
	const DIALOGNODE_IS_NOT_CHILD_OF_CANVASLAYER = "DIALOGNODE_IS_NOT_CHILD_OF_CANVASLAYER"
	
	static func not_found_timeline():
		var tml_res = load("res://addons/dialog_plugin/Resources/TimelineResource.gd")
		var txt_evnt = load("res://addons/dialog_plugin/Resources/Events/TextEvent/TextEvent.gd")
		var chara = load("res://addons/dialog_plugin/Resources/CharacterResource.gd")
		var _timeline = tml_res.new()
		var _text_event = txt_evnt.new()
		var _character = chara.new()
		
		_character.name = Dialog_ERROR
		_character.color = Color.red
		
		_text_event.character = _character
		_text_event.translation_key = TIMELINE_NOT_SELECTED
		_timeline.events.append(_text_event)
		
		return _timeline

class Logger:
	const Print = preload("res://addons/dialog_plugin/Other/console_print/print.gd")
	
	static func _parse_mark(from:String) -> String:
		return from.format({"mark":Dialog_MARK})
	
	static func _parse_level(from:String, level:String) -> String:
		return from.format({"level":level})
	
	static func _parse_object_class(from:String, object_class:String) -> String:
		return from.format({"object_class":object_class})
	
	static func _parse_message(from:String, message:String) -> String:
		return from.format({"message":message})
	
	static func _get_template_message() -> String:
		return "{mark} {level} [{object_class}] {message}"
	
	static func _get_formatted_message(from) -> String:
		var _formatted_message:String = ""
		match typeof(from):
			var _anything_else:
				_formatted_message = str(from)
		return _formatted_message
	
	
	static func _build_message_from(level:String, what, object_class:String="") -> String:
		var _message:String = _get_template_message()
		
		_message = _parse_mark(_message)
		_message = _parse_level(_message, level)
		_message = _parse_object_class(_message, object_class)
		_message = _parse_message(_message, _get_formatted_message(what))
		
		return _message
	
	
	static func print_info(who:Object, vargs) -> void:
		if not OS.is_debug_build():
			return
		
		var _message:String = _build_message_from(Dialog_INFO, vargs, who.get_class())
		prints(">", _message)
	
	
	static func print_debug(who:Object, vargs) -> void:
		if not OS.is_stdout_verbose():
			return
		
		var _message:String = _build_message_from(Dialog_DEBUG, vargs, who.get_class())
		Print.s(Print.YELLOW, [">", _message])
	
	
	static func print_error(who:Object, vararg) -> void:
		var _message:String = _build_message_from(Dialog_ERROR, vararg, who.get_class())
		printerr(_message)
		
	
	static func verify(condition:bool, error_message:String="Something failed. Verify the debugger") -> void:
		var _err_msg:String = "{mark} {message}".format({"mark":Dialog_ERROR, "message":error_message})
		assert(condition, _err_msg)


# Based on: https://www.askpython.com/python/built-in-methods/python-eval
## Evaluates an string, excecutes it and returns the result
static func evaluate(input:String, global:Object=null, locals:Dictionary={}, _show_error:bool=true):
	var _evaluated_value = null
	var _expression = Expression.new()
	
	var _err = _expression.parse(input, PoolStringArray(locals.keys()))
	
	if _err != OK:
		push_warning(_expression.get_error_text())
	else:
		_evaluated_value = _expression.execute(locals.values(), global, _show_error)
		
		if _expression.has_execute_failed():
			return input
		
	return _evaluated_value


static func can_evaluate(input:String, global:Object=null, locals:Dictionary={}) -> bool:
	var _evaluated_value = null
	var _expression = Expression.new()
	
	var _err = _expression.parse(input, PoolStringArray(locals.keys()))
	
	if _err != OK:
		push_warning(_expression.get_error_text())
	else:
		_evaluated_value = _expression.execute(locals.values(), global, false)
		
		if not _expression.has_execute_failed():
			return true
		
	return false

# Util function to generate property dictionary
static func get_property_dict(property_name:String,property_type:int,property_hint:int=PROPERTY_HINT_NONE,property_hint_string:String="",property_usage:int=PROPERTY_USAGE_STORAGE) -> Dictionary:
	return {"name":property_name, "type":property_type, "hint":property_hint, "hint_string":property_hint_string, "usage":property_usage}


static func get_event_property_dict(property_name:String,property_type:int,property_hint:int=PROPERTY_HINT_NONE,property_hint_string:String="") -> Dictionary:
	var condition:int = PROPERTY_USAGE_STORAGE | PROPERTY_USAGE_SCRIPT_VARIABLE
	var dict:Dictionary = get_property_dict(property_name, property_type, property_hint, property_hint_string, condition)
	return dict


# Util function to get a dictionary of object property:value
static func get_property_values_from(object:Object) -> Dictionary:
	if object == null:
		return {}
	var dict = {}
	# Hope this doesn't freeze the engine per call
	for property in object.get_property_list():
		dict[property.name] = object.get(property.name)
	return dict
