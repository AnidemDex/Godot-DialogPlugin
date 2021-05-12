tool
class_name DialogCharacterJoinEvent
extends DialogEventResource

# DialogCharacterResource
export(Resource) var character = null
export(int) var selected_portrait = 0
# Refer to DialogPortraitManager.Position
export(DialogPortraitManager.Position) var selected_position = 0
# Refer to DialogPortraitManager.PAnimation
export(DialogPortraitManager.PAnimation) var selected_animation = 0
export(bool) var skip = true

var _PortraitManager: DialogPortraitManager

func _init():
	resource_name = "CharacterJoinEvent"
	event_editor_scene_path = "res://addons/dialog_plugin/Nodes/editor_event_nodes/character_event/join_event_node/join_event_node.tscn"


func excecute(caller:DialogBaseNode) -> void:
	# Parent function must be called at the start
	.excecute(caller)

	if not character:
		finish()
		return
	
	_caller = caller
	_caller.visible = true
	_PortraitManager = (caller.PortraitManager as DialogPortraitManager)
	
	if not _PortraitManager:
		finish()
		return
	
	_PortraitManager.visible = true
	_PortraitManager.connect("portrait_added", self, "_on_portrait_added", [], CONNECT_ONESHOT)
	
	var _character_portraits:Array = character.portraits.get_resources()
	var _portrait = _character_portraits[selected_portrait]
	
	_PortraitManager.add_portrait(
		character, 
		_portrait,
		selected_position,
		selected_animation
		)


func _on_portrait_added()->void:
	finish(skip)
