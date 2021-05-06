tool

const DialogDB = preload("res://addons/dialog_plugin/Core/DialogDatabase.gd")

class Error:
	const Dialog_ERROR = "[Dialog Error]"
	const TIMELINE_NOT_FOUND = "TIMELINE_NOT_FOUND"
	const TIMELINE_NOT_SELECTED = "TIMELINE_NOT_SELECTED"
	
	const DIALOGNODE_IS_NOT_CHILD_OF_CANVASLAYER = "DIALOGNODE_IS_NOT_CHILD_OF_CANVASLAYER"
	
	static func not_found_timeline() -> DialogTimelineResource:
		var _timeline = DialogTimelineResource.new()
		var _text_event = DialogTextEvent.new()
		var _char_join_event = DialogCharacterJoinEvent.new()
		var _character = DialogCharacterResource.new()
		var _portrait = DialogPortraitResource.new()
		
		_portrait.image = load("res://icon.png")
		
		_character.name = Dialog_ERROR
		_character.color = Color.red
		_character.portraits.add(_portrait)
		
		_char_join_event.character = _character
		
		_text_event.character = _character
		_text_event.translation_key = TIMELINE_NOT_SELECTED
		_timeline.events.add(_char_join_event)
		_timeline.events.add(_text_event)
		
		return _timeline

class Logger:
	const INFO = "[Dialog]"
	
	static func print(who:Object, what) -> void:
		if not DialogDB.get_editor_configuration().editor_debug_mode:
			return
		
		var _info = "[Dialog]"
		
		match typeof(what):
			var anything_else:
				print("{mark} [{who}] {info}".format(
					{"mark":INFO, 
					"info":what,
					"who":who.get_class(),
					}))
