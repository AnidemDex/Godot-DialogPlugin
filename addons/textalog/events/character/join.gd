extends "res://addons/textalog/events/character/char_event.gd"
class_name EventCharacterJoin

export(float, 0, 1, 0.01) var percent_position_x = 0.414 setget set_percent_x
export(float, 0, 1, 0.01) var percent_position_y = 0.275 setget set_percent_y
export(float, -360, 360, 0.1) var rotation = 0 setget set_rotation
export(bool) var flip_h:bool = false setget set_flip_h
export(bool) var flip_v:bool = false setget set_flip_v

func _init() -> void:
	event_name = "Join"
	event_hint = "Make a character portrait joins in the scene."
	event_preview_string = "{character_name} will join with expression {expression_name}. X:{percent_position_x} | Y:{percent_position_y}"
	event_icon = load("res://addons/textalog/assets/icons/event_icons/character_join.png") as Texture


func _execute() -> void:
	event_node = event_node as DialogNode
	if not is_instance_valid(event_node):
		finish()
		return
	
	var portrait_manager:PortraitManager = event_node.portrait_manager
	
	if not is_instance_valid(portrait_manager):
		finish()
		return
	
	event_node.visible = true
	portrait_manager.visible = true
	
	portrait_manager.connect("portrait_added", self, "_on_portrait_added", [], CONNECT_ONESHOT)
	
	portrait_manager.add_portrait(character, get_selected_portrait(), Vector2(percent_position_x, percent_position_y), rotation, flip_h, flip_v)


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


func _on_portrait_added(_c, _p) -> void:
	finish()
