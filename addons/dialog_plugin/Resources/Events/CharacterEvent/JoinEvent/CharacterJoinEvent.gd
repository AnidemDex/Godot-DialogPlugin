tool
class_name DialogCharacterJoinEvent
extends DialogCharacterEvent

export(float, 0, 1, 0.01) var percent_position_x = 0.414
export(float, 0, 1, 0.01) var percent_position_y = 0.275
export(float, -360, 360, 0.1) var rotation = 0
export(bool) var flip_h:bool = false
export(bool) var flip_v:bool = false

var _PortraitManager: DialogPortraitManager

func _init():
	resource_name = "CharacterJoinEvent"
	event_editor_scene_path = "res://addons/dialog_plugin/Nodes/editor_event_nodes/character_event/join_event_node/join_event_node.tscn"
	skip = true


func execute(caller:DialogBaseNode) -> void:
	# Parent function must be called at the start
	.execute(caller)
	
	_caller = caller
	_caller.visible = true
	_PortraitManager = (caller.PortraitManager as DialogPortraitManager)
	
	if not _PortraitManager:
		finish(true)
		return
	
	_PortraitManager.visible = true
	_PortraitManager.connect("portrait_added", self, "_on_portrait_added", [], CONNECT_ONESHOT)
	
	_PortraitManager.add_portrait(character, get_selected_portrait(), Vector2(percent_position_x, percent_position_y), rotation, flip_h, flip_v)


func _on_portrait_added(_c, _p)->void:
	finish(skip)
