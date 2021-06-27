tool
class_name DialogCharacterLeaveEvent
extends DialogCharacterEvent

func _init():
	resource_name = "CharacterLeaveEvent"
	event_editor_scene_path = "res://addons/dialog_plugin/Nodes/editor_event_nodes/character_event/leave_event_node/leave_event_node.tscn"
	skip = true


func execute(caller:DialogBaseNode) -> void:
	var PortraitManager:DialogPortraitManager = caller.PortraitManager
	if not PortraitManager:
		finish(true)
		return
	
	if not character:
		var _characters = PortraitManager.portraits.keys()
		for _chara in _characters:
			PortraitManager.remove_portrait(_chara)
		PortraitManager.portraits.clear()
	else:
		PortraitManager.remove_portrait(character)
	
	finish(skip)
