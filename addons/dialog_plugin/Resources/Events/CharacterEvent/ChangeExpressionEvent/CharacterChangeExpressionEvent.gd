tool
class_name DialogCharacterChangeExpressionEvent
extends DialogCharacterEvent


func _init() -> void:
	resource_name = "CharacterChangeExpression"
	event_editor_scene_path = "res://addons/dialog_plugin/Nodes/editor_event_nodes/character_event/change_expression/change_expression_event_node.tscn"
	skip = true


func excecute(caller:DialogBaseNode) -> void:
	# Parent function must be called at the start
	.excecute(caller)
	if not caller.PortraitManager or not character:
		finish(true)
		return
	
	var _PortraitManager:DialogPortraitManager = caller.PortraitManager
	
	_PortraitManager.change_portrait(character, selected_portrait)
	
	finish()
