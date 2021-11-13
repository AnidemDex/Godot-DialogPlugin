extends Control
class_name DialogManager

## 
## Base class for all dialogue nodes.
##
## @desc:
##     This node takes cares about displaying text and showing an indicator.
##
## @tutorial(Online Documentation): https://anidemdex.gitbook.io/godot-dialog-plugin/documentation/node-class/class_dialog-dialogue-node
##


signal text_displayed
signal character_displayed(character)

export(NodePath) var TextNode_path:NodePath
export(NodePath) var TextTimer_path:NodePath
export(float) var text_speed:float = 0.02

onready var text_node:RichTextLabel = (get_node_or_null(TextNode_path) as RichTextLabel)
onready var _text_timer:Timer = get_node_or_null(TextTimer_path) as Timer


func display_all_text() -> void:
	if text_node.visible_characters >= text_node.get_total_character_count():
		return
	text_node.visible_characters = text_node.get_total_character_count() -1
	_update_displayed_text()


func display_text() -> void:
	_text_timer.start(text_speed)


func set_text(text:String) -> void:
	text_node.bbcode_text = text
	text_node.visible_characters = 1


func add_text(text:String) -> void:
	text_node.append_bbcode(text)


func _update_displayed_text() -> void:
	var _character = _get_current_character()
	emit_signal("character_displayed", _character)
	text_node.visible_characters += 1
	
	if text_node.visible_characters < text_node.get_total_character_count():
		_text_timer.start(text_speed)
	else:
		_text_timer.stop()
		emit_signal("text_displayed")


func _get_current_character() -> String:
	var _text:String = text_node.text
	
	if _text == "":
		_text = " "
	
	var _text_length = _text.length()-1
	var _text_visible_characters = clamp(text_node.visible_characters, 0, _text_length)
	var _current_character = _text[min(_text_length, _text_visible_characters)]
	return _current_character
