tool
class_name DialogCharacterLeaveEvent
extends DialogEventResource

export(Resource) var character = null

func _init():
	resource_name = "CharacterLeaveEvent"
	event_editor_scene_path = "res://addons/dialog_plugin/Nodes/editor_event_nodes/character_event/leave_event_node/leave_event_node.tscn"


func excecute(caller) -> void:
	.excecute(caller)
	
	if not character:
		for portrait in caller.PortraitsNode.get_children():
			portrait.queue_free()
	
	finish()
