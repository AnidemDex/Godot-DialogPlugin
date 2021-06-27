tool

class Error:
	const Dialog_ERROR = "[Dialog Error]"
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
		_timeline.events.add(_text_event)
		
		return _timeline

class Logger:
	const INFO = "[Dialog]"
	
	static func print(who:Object, what) -> void:
		
		var _info = "[Dialog]"
		
		match typeof(what):
			var anything_else:
				print("{mark} [{who}] {info}".format(
					{"mark":INFO, 
					"info":what,
					"who":who.get_class(),
					}))

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
