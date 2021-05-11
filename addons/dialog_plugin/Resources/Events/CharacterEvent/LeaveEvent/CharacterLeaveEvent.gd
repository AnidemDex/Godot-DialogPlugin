tool
class_name DialogCharacterLeaveEvent
extends DialogEventResource

export(Resource) var character = null

func excecute(caller) -> void:
	.excecute(caller)
	
	if not character:
		for portrait in caller.PortraitsNode.get_children():
			portrait.queue_free()
	
	finish()

func get_event_editor_node() -> DialogEditorEventNode:
	var _scene_resource:PackedScene = load("res://addons/dialog_plugin/Nodes/editor_event_nodes/character_event/leave_event_node/leave_event_node.tscn")
	_scene_resource.resource_local_to_scene = true
	var _instance = _scene_resource.instance(PackedScene.GEN_EDIT_STATE_INSTANCE)
	_instance.base_resource = self
	return _instance
