tool
extends "res://addons/textalog/events/character/char_event.gd"
class_name EventCharacterChangeExpression

func _init() -> void:
	event_name = "Change expression"
	event_hint = "Changes the portrait of the character"
	event_preview_string = "[{character_name}] expression will be [{expression_name}]"
	event_icon = load("res://addons/textalog/assets/icons/event_icons/change_expression.png") as Texture


func _execute() -> void:
	var node = get_event_node() as DialogNode
	if not is_instance_valid(node):
		finish()
		return
	
	var portrait_manager:PortraitManager = node.portrait_manager
	
	if not is_instance_valid(portrait_manager):
		finish()
		return
	
	portrait_manager.connect("portrait_changed", self, "_on_portrait_changed", [], CONNECT_ONESHOT)
	
	portrait_manager.change_portrait(character, get_selected_portrait())


func _on_portrait_changed(_c, _p) -> void:
	finish()
