tool
class_name DialogDialogueManager
extends Control

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
	TextNode.visible_characters = TextNode.get_total_character_count()


func display_text() -> void:
	_TextTimer.start(text_speed)


func set_text(text:String) -> void:
	TextNode.bbcode_text = text
	TextNode.visible_characters = 0


func add_text(text:String) -> void:
	TextNode.append_bbcode(text)


func _update_displayed_text() -> void:
	TextNode.visible_characters += 1
	var _text:String = TextNode.text
	var _character = _text[min(TextNode.visible_characters-1, _text.length()-1)]
	emit_signal("character_displayed", _character)
	
	if TextNode.visible_characters < TextNode.get_total_character_count():
		_TextTimer.start(text_speed)
	else:
		_TextTimer.stop()
		emit_signal("text_displayed")
