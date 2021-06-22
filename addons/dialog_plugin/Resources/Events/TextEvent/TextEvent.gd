tool
class_name DialogTextEvent
extends DialogEventResource

const SAME_AS_TEXT = "__SAME_AS_TEXT__"

# https://github.com/godotengine/godot/pull/37324
var EventTimer = preload("TextEventTimer.gd")

export(String, MULTILINE) var text:String = ""
export(Resource) var character = null
export(String) var translation_key = SAME_AS_TEXT

var _timer = null
var _DialogNode:DialogDialogueNode = null


func _init():
	resource_name = "TextEvent"
	event_editor_scene_path = "res://addons/dialog_plugin/Nodes/editor_event_nodes/text_event_node/text_event_node.tscn"


func execute(caller:DialogBaseNode) -> void:
	.execute(caller)
	
	_caller = caller
	_DialogNode = caller.DialogNode
	
	if not _timer or not(is_instance_valid(_timer)):
		_timer = EventTimer.new()
		_timer.caller = _caller
		_caller.add_child(_timer)
	if not _timer.is_connected("timeout", self, "_on_TextTimer_timeout"):
		var _err = _timer.connect("timeout", self, "_on_TextTimer_timeout")
		assert(_err == OK)

	caller.visible = true
	if _DialogNode:
		_DialogNode.visible = true
	
	_update_text()
	
	if not character:
		# Default speaker should be displayed here
		character = DialogCharacterResource.new()

	_update_name()


func _update_text() -> void:
	if _DialogNode:
		var _text = text
		if translation_key != SAME_AS_TEXT:
			_text = TranslationService.translate(translation_key)
		var _variables = load(VARIABLES_PATH).variables
		_DialogNode.TextNode.bbcode_text = _text.format(_variables)
		_DialogNode.TextNode.visible_characters = 0
		_timer.start(_DialogNode.text_speed)


func _update_name() -> void:
	if _DialogNode:
		if _DialogNode.NameNode:
			if not character.name:
				_DialogNode.NameNode.visible = false
			else:
				_DialogNode.NameNode.visible = true
			_DialogNode.NameNode.text = character.display_name
			_DialogNode.NameNode.set('custom_colors/font_color', character.color)


func _on_TextTimer_timeout():
	_DialogNode.TextNode.visible_characters += 1
	if _DialogNode.TextNode.visible_characters < _DialogNode.TextNode.get_total_character_count():
		_timer.start(_DialogNode.text_speed)
	else:
		if is_instance_valid(_timer):
			_timer.stop()
			_timer.queue_free()
		finish()
