tool
class_name DialogDialogueManager
extends Control

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
export(NodePath) var NameNode_path:NodePath
export(NodePath) var NextIndicator_path:NodePath
export(NodePath) var TextTimer_path:NodePath
export(float) var text_speed:float = 0.02

var next_action:String = "ui_accept"

var event_finished = false


onready var TextNode:RichTextLabel = (get_node_or_null(TextNode_path) as RichTextLabel)
onready var NameNode:Label = (get_node_or_null(NameNode_path) as Label)
onready var NextIndicatorNode := get_node_or_null(NextIndicator_path)
onready var _TextTimer:Timer = get_node_or_null(TextTimer_path) as Timer

func _process(delta: float) -> void:
	if not NextIndicatorNode:
		return
	if Engine.editor_hint:
		return
	NextIndicatorNode.visible = event_finished


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(next_action):
		display_all_text()


func display_all_text() -> void:
	if TextNode.visible_characters >= TextNode.get_total_character_count():
		return
	TextNode.visible_characters = TextNode.get_total_character_count() -1
	_update_displayed_text()


func display_text() -> void:
	_TextTimer.start(text_speed)


func set_text(text:String) -> void:
	TextNode.bbcode_text = text
	TextNode.visible_characters = 1


func add_text(text:String) -> void:
	TextNode.append_bbcode(text)


func _update_displayed_text() -> void:
	var _character = _get_current_character()
	emit_signal("character_displayed", _character)
	TextNode.visible_characters += 1
	
	if TextNode.visible_characters < TextNode.get_total_character_count():
		_TextTimer.start(text_speed)
	else:
		_TextTimer.stop()
		emit_signal("text_displayed")


func _get_current_character() -> String:
	var _text:String = TextNode.text
	var _text_length = _text.length()-1
	var _text_visible_characters = clamp(TextNode.visible_characters, 0, _text_length)
	var _current_character = _text[min(_text_length, _text_visible_characters)]
	return _current_character
