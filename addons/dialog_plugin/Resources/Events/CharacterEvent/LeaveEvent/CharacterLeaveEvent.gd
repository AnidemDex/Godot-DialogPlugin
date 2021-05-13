tool
class_name DialogCharacterLeaveEvent
extends DialogEventResource

export(Resource) var character = null

func _init():
	resource_name = "CharacterLeaveEvent"
	event_editor_scene_path = "res://addons/dialog_plugin/Nodes/editor_event_nodes/character_event/leave_event_node/leave_event_node.tscn"
	skip = true


func excecute(caller:DialogBaseNode) -> void:
	.excecute(caller)
	
	var PortraitManager:DialogPortraitManager = caller.PortraitManager
	if not PortraitManager:
		finish(true)
		return
	
	if not character:
		for portrait_node in PortraitManager.portraits.values():
			portrait_node.queue_free()
		PortraitManager.portraits.clear()
	else:
		if character in PortraitManager.portraits:
			PortraitManager.portraits.get(character).queue_free()
			PortraitManager.portraits.erase(character)
	
	finish(skip)
