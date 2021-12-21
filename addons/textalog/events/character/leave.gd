tool
extends "res://addons/textalog/events/character/char_event.gd"
class_name EventCharacterLeave

func _init() -> void:
	event_name = "Leave"
	event_hint = "Make a character portrait leaves the scene."
	event_preview_string = "[{character_name}] will leave the scene"
	event_icon = load("res://addons/textalog/assets/icons/event_icons/character_leave.png") as Texture


func _execute() -> void:
	event_node = event_node as DialogNode
	if not is_instance_valid(event_node):
		finish()
		return
	
	var portrait_manager:PortraitManager = event_node.portrait_manager
	
	if not is_instance_valid(portrait_manager):
		finish()
		return
	
	portrait_manager.connect("portrait_removed", self, "_on_portrait_removed", [], CONNECT_ONESHOT)
	
	portrait_manager.remove_portrait(character)


func _on_portrait_removed(_c) -> void:
	finish()


func _get(property: String):
	if property == "selected_portrait_ignore":
		return true
