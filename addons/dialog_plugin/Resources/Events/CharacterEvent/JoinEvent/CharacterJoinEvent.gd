tool
class_name DialogCharacterJoinEvent
extends DialogCharacterEvent

export(float, 0, 1, 0.01) var percent_position_x = 0.414 setget set_percent_x
export(float, 0, 1, 0.01) var percent_position_y = 0.275 setget set_percent_y
export(float, -360, 360, 0.1) var rotation = 0 setget set_rotation
export(bool) var flip_h:bool = false setget set_flip_h
export(bool) var flip_v:bool = false setget set_flip_v

var _PortraitManager: DialogPortraitManager

func _init():
	resource_name = "CharacterJoinEvent"
	event_icon = load("res://addons/dialog_plugin/assets/Images/icons/event_icons/character/character_join.png") as Texture
	skip = true
	event_editor_scene_path = "res://addons/dialog_plugin/Nodes/editor_event_node/custom_nodes/character_join/character_join_event_node.tscn"


func execute(caller:DialogBaseNode) -> void:
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


func set_percent_x(value:float) -> void:
	percent_position_x = clamp(value, 0, 1)
	emit_changed()
	property_list_changed_notify()


func set_percent_y(value:float) -> void:
	percent_position_y = clamp(value, 0, 1)
	emit_changed()
	property_list_changed_notify()


func set_rotation(value:float) -> void:
	rotation = clamp(value, -360, 360)
	emit_changed()
	property_list_changed_notify()


func set_flip_h(value:bool) -> void:
	flip_h = value
	emit_changed()
	property_list_changed_notify()


func set_flip_v(value:bool) -> void:
	flip_v = value
	emit_changed()
	property_list_changed_notify()
